-- =============================================================================
-- Fully Normalized DDL Schema: Grand Vista Hotel Management System
-- Portfolio Component: Portfolio 1 - Database Design & Modelling
-- Normalization Level: 3NF / BCNF Compliant
-- Target Database: PostgreSQL
-- =============================================================================

-- Clean build teardown
DROP TABLE IF EXISTS check_in_check_out CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS rooms CASCADE;
DROP TABLE IF EXISTS room_types CASCADE;
DROP TABLE IF EXISTS guests CASCADE;

DROP TYPE IF EXISTS room_status_enum CASCADE;
DROP TYPE IF EXISTS booking_status_enum CASCADE;
DROP TYPE IF EXISTS payment_status_enum CASCADE;

-- Enums for Domain Integrity
CREATE TYPE room_status_enum AS ENUM ('available', 'occupied', 'maintenance');
CREATE TYPE booking_status_enum AS ENUM ('confirmed', 'checked_in', 'checked_out', 'cancelled');
CREATE TYPE payment_status_enum AS ENUM ('pending', 'completed', 'refunded');

-- 1. Guests Table
CREATE TABLE guests (
    guest_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Room Types Table (Eliminates Transitive Dependency)
CREATE TABLE room_types (
    room_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    daily_rate NUMERIC(10, 2) NOT NULL,
    capacity INT NOT NULL DEFAULT 2,
    CONSTRAINT chk_positive_rate CHECK (daily_rate > 0),
    CONSTRAINT chk_positive_capacity CHECK (capacity > 0)
);

-- 3. Rooms Table (References room_types)
CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type_id INT NOT NULL,
    status room_status_enum NOT NULL DEFAULT 'available',
    CONSTRAINT fk_room_type FOREIGN KEY (room_type_id) 
        REFERENCES room_types(room_type_id) ON DELETE RESTRICT
);

-- 4. Bookings Table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL,
    status booking_status_enum NOT NULL DEFAULT 'confirmed',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_guest FOREIGN KEY (guest_id) 
        REFERENCES guests(guest_id) ON DELETE RESTRICT,
    CONSTRAINT fk_booking_room FOREIGN KEY (room_id) 
        REFERENCES rooms(room_id) ON DELETE RESTRICT,
    CONSTRAINT chk_dates CHECK (check_out_date > check_in_date),
    CONSTRAINT chk_positive_total CHECK (total_amount >= 0)
);

-- 5. Payments Table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_status payment_status_enum NOT NULL DEFAULT 'pending',
    payment_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) 
        REFERENCES bookings(booking_id) ON DELETE CASCADE,
    CONSTRAINT chk_positive_payment CHECK (amount > 0)
);

-- 6. Check-In / Check-Out Log Table
CREATE TABLE check_in_check_out (
    record_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL UNIQUE,
    actual_check_in TIMESTAMP NOT NULL,
    actual_check_out TIMESTAMP,
    room_key_issued BOOLEAN NOT NULL DEFAULT TRUE,
    notes TEXT,
    CONSTRAINT fk_log_booking FOREIGN KEY (booking_id) 
        REFERENCES bookings(booking_id) ON DELETE CASCADE
);
