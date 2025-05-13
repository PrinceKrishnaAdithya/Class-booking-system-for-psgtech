import streamlit as st
import pandas as pd
import mysql.connector
from datetime import datetime, timedelta
import calendar
import base64
import os

# Set page configuration
st.set_page_config(
    page_title="College Class Booking System",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Function to get base64 encoded image
def get_image_as_base64(image_path):
    if os.path.exists(image_path):
        with open(image_path, "rb") as img_file:
            return base64.b64encode(img_file.read()).decode()
    return None

# Get wave image as base64
wave_image_base64 = get_image_as_base64("wave.jpg")

# Custom CSS to make buttons square
st.markdown("""
<style>
    .stButton button {
        width: 100%;
        border-radius: 4px;
        height: 40px;
        padding: 0px;
    }
    .stButton {
        width: 100%;
    }
</style>
""", unsafe_allow_html=True)

# Database connection function
@st.cache_resource
def init_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="CHARLIEechoDELTA",  # Replace with your actual password
        database="campus_db"  # Replace with your actual database name
    )

# Function to execute query and return dataframe
@st.cache_data(ttl=5)  # Cache for 5 seconds only
def run_query(query, params=None):
    conn = init_connection()
    cursor = conn.cursor(dictionary=True)
    if params:
        cursor.execute(query, params)
    else:
        cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    return pd.DataFrame(results) if results else pd.DataFrame()

# Function to execute query without caching (for updates)
def execute_query(query, params=None):
    conn = init_connection()
    cursor = conn.cursor()
    try:
        if params:
            cursor.execute(query, params)
        else:
            cursor.execute(query)
        conn.commit()
        return True
    except Exception as e:
        st.error(f"Error executing query: {e}")
        conn.rollback()
        return False
    finally:
        cursor.close()

# Get all buildings
def get_buildings():
    return run_query("SELECT * FROM Building ORDER BY building_name")

# Get rooms by building
def get_rooms_by_building(building_id):
    return run_query("""
        SELECT r.*, b.building_name 
        FROM Room r
        JOIN Building b ON r.building_id = b.building_id
        WHERE r.building_id = %s
        ORDER BY r.room_number
    """, (building_id,))

# Get bookings for a specific room on a specific day
def get_bookings_for_room(room_id, day_of_week):
    return run_query("""
        SELECT b.*, t.start_time, t.end_time, s.subject_name, s.subject_code, 
               st.staff_name, c.course_name
        FROM Booking b
        JOIN Timings t ON b.timing_id = t.timing_id
        JOIN Subject s ON b.subject_id = s.subject_id
        JOIN Staff st ON b.staff_id = st.staff_id
        JOIN Course c ON b.course_id = c.course_id
        WHERE b.room_id = %s AND b.day_of_week = %s
        ORDER BY t.start_time
    """, (room_id, day_of_week))

# Get all time slots
def get_time_slots():
    return run_query("SELECT * FROM Timings ORDER BY start_time")

# Get room facilities
def get_room_facilities(room_id):
    return run_query("""
        SELECT f.facility_name
        FROM RoomFacility rf
        JOIN Facility f ON rf.facility_id = f.facility_id
        WHERE rf.room_id = %s
    """, (room_id,))

# Get all staff
def get_staff():
    return run_query("SELECT * FROM Staff ORDER BY staff_name")

# Get all courses
def get_courses():
    return run_query("SELECT * FROM Course ORDER BY course_name")

# Get all subjects
def get_subjects():
    return run_query("SELECT * FROM Subject ORDER BY subject_name")

# Book a room
def book_room(staff_id, course_id, subject_id, room_id, timing_id, day_of_week):
    success = execute_query("""
        INSERT INTO Booking 
        (staff_id, course_id, subject_id, room_id, timing_id, day_of_week, status)
        VALUES (%s, %s, %s, %s, %s, %s, 'Confirmed')
    """, (staff_id, course_id, subject_id, room_id, timing_id, day_of_week))
    
    if success:
        # Clear the cache to ensure fresh data is loaded
        run_query.clear()
    
    return success

# Check if a room is booked at a specific time
def is_room_booked(room_id, timing_id, day_of_week):
    result = run_query("""
        SELECT COUNT(*) as count
        FROM Booking
        WHERE room_id = %s AND timing_id = %s AND day_of_week = %s
    """, (room_id, timing_id, day_of_week))
    return result.iloc[0]['count'] > 0 if not result.empty else False

# Format time to HH:MM
def format_time(time_obj):
    if isinstance(time_obj, datetime):
        return time_obj.strftime('%H:%M')
    elif isinstance(time_obj, str):
        # Try to parse the string as time
        try:
            return datetime.strptime(time_obj, '%H:%M:%S').strftime('%H:%M')
        except:
            return time_obj
    else:
        return str(time_obj)

# Main application
def main():
    st.title("College Class Booking System")
    
    # Sidebar for filters
    st.sidebar.header("Filters")
    
    # Get current day of week
    today = datetime.now()
    day_of_week = calendar.day_name[today.weekday()]
    
    # Day selection
    days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    selected_day = st.sidebar.selectbox("Select Day", days, index=days.index(day_of_week))
    
    # Building selection
    buildings = get_buildings()
    if buildings.empty:
        st.error("No buildings found in the database.")
        return
    
    selected_building = st.sidebar.selectbox(
        "Select Building",
        buildings['building_id'].tolist(),
        format_func=lambda x: buildings.loc[buildings['building_id'] == x, 'building_name'].iloc[0]
    )
    
    # Get rooms for selected building
    rooms = get_rooms_by_building(selected_building)
    if rooms.empty:
        st.warning(f"No rooms found in the selected building.")
        return
    
    # Get time slots
    time_slots = get_time_slots()
    if time_slots.empty:
        st.error("No time slots found in the database.")
        return
    
    # Display timetable grid
    st.header(f"Timetable for {buildings.loc[buildings['building_id'] == selected_building, 'building_name'].iloc[0]} - {selected_day}")
    
    # Create a grid layout
    cols = st.columns(len(time_slots) + 1)
    
    # Header row with time slots
    cols[0].markdown("**Room**")
    for i, (_, slot) in enumerate(time_slots.iterrows()):
        start_time = format_time(slot['start_time'])
        end_time = format_time(slot['end_time'])
        cols[i+1].markdown(f"**{start_time} - {end_time}**")
    
    # Room rows with booking status
    for _, room in rooms.iterrows():
        row_cols = st.columns(len(time_slots) + 1)
        row_cols[0].markdown(f"**{room['room_number']}**")
        
        for i, (_, slot) in enumerate(time_slots.iterrows()):
            is_booked = is_room_booked(room['room_id'], slot['timing_id'], selected_day)
            
            # Get booking details if booked
            booking_details = None
            if is_booked:
                bookings = get_bookings_for_room(room['room_id'], selected_day)
                booking = bookings[bookings['timing_id'] == slot['timing_id']]
                if not booking.empty:
                    booking_details = booking.iloc[0]
            
            # Create a container with background color based on booking status
            with row_cols[i+1].container():
                if is_booked:
                    # Booked slot - dark background
                    st.markdown(
                        f"""
                        <div style="background-color: #4a5568; color: white; padding: 10px; border-radius: 5px; min-height: 80px;">
                            <strong>{booking_details['subject_code']}</strong><br>
                            {booking_details['staff_name']}<br>
                            {booking_details['course_name']}
                        </div>
                        """,
                        unsafe_allow_html=True
                    )
                else:
                    # Free slot - wave image background
                    if wave_image_base64:
                        st.markdown(
                            f"""
                            <div style="background-image: url('data:image/jpeg;base64,{wave_image_base64}'); 
                                        background-size: cover; 
                                        background-position: center; 
                                        padding: 10px; 
                                        border-radius: 5px; 
                                        min-height: 80px;">
                            </div>
                            """,
                            unsafe_allow_html=True
                        )
                    else:
                        # Fallback if image not found
                        st.markdown(
                            f"""
                            <div style="background-color: #f7fafc; padding: 10px; border-radius: 5px; min-height: 80px;">
                            </div>
                            """,
                            unsafe_allow_html=True
                        )
                    
                    # Use a unique key for each button
                    button_key = f"book_{room['room_id']}_{slot['timing_id']}"
                    
                    if st.button("Book", key=button_key):
                        # Show booking form
                        st.session_state.show_booking_form = True
                        st.session_state.selected_room = room
                        st.session_state.selected_slot = slot
                        st.session_state.selected_day = selected_day
                        st.experimental_rerun()
    
    # Booking form
    if st.session_state.get('show_booking_form', False):
        show_booking_form()

def show_booking_form():
    st.subheader("Book a Class")
    
    room = st.session_state.selected_room
    slot = st.session_state.selected_slot
    day = st.session_state.selected_day
    
    # Display room details
    st.markdown(f"**Room:** {room['room_number']} ({room['building_name']})")
    st.markdown(f"**Capacity:** {room['capacity']}")
    st.markdown(f"**Room Type:** {room['room_type']}")
    st.markdown(f"**Floor:** {room['floor']}")
    
    # Get room facilities
    facilities = get_room_facilities(room['room_id'])
    if not facilities.empty:
        facility_list = ", ".join(facilities['facility_name'].tolist())
        st.markdown(f"**Facilities:** {facility_list}")
    
    # Display time slot
    start_time = format_time(slot['start_time'])
    end_time = format_time(slot['end_time'])
    st.markdown(f"**Time Slot:** {start_time} - {end_time}")
    st.markdown(f"**Day:** {day}")
    
    # Form for booking
    with st.form("booking_form"):
        # Get staff, courses, and subjects for dropdowns
        staff = get_staff()
        courses = get_courses()
        subjects = get_subjects()
        
        # Dropdowns for selection
        selected_staff = st.selectbox(
            "Select Staff",
            staff['staff_id'].tolist(),
            format_func=lambda x: staff.loc[staff['staff_id'] == x, 'staff_name'].iloc[0]
        )
        
        selected_course = st.selectbox(
            "Select Course",
            courses['course_id'].tolist(),
            format_func=lambda x: courses.loc[courses['course_id'] == x, 'course_name'].iloc[0]
        )
        
        selected_subject = st.selectbox(
            "Select Subject",
            subjects['subject_id'].tolist(),
            format_func=lambda x: f"{subjects.loc[subjects['subject_id'] == x, 'subject_code'].iloc[0]} - {subjects.loc[subjects['subject_id'] == x, 'subject_name'].iloc[0]}"
        )
        
        # Submit button
        submitted = st.form_submit_button("Confirm Booking")
        
        if submitted:
            # Book the room
            if book_room(selected_staff, selected_course, selected_subject, room['room_id'], slot['timing_id'], day):
                st.success("Room booked successfully!")
                # Reset form state
                st.session_state.show_booking_form = False
                # Force a full page refresh to update all data
                st.experimental_rerun()
            else:
                st.error("Failed to book the room. Please try again.")
    
    # Cancel button
    if st.button("Cancel"):
        st.session_state.show_booking_form = False
        st.experimental_rerun()

# Initialize session state
if 'show_booking_form' not in st.session_state:
    st.session_state.show_booking_form = False

# Check if we need to refresh after booking
if st.session_state.get('refresh_after_booking', False):
    st.session_state.refresh_after_booking = False
    # Clear all caches to ensure fresh data
    run_query.clear()

# Run the app
if __name__ == "__main__":
    main()