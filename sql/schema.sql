-- =============================================================================
-- Grand Vista Hotel Management System - DDL Implementation Script
-- Portfolio 1: Database Design and Modelling
-- Target Database: PostgreSQL / Standard Relational SQL
-- =============================================================================

-- Drop existing tables if re-executing script (clean build order)
DROP TABLE IF EXISTS check_in_check_out CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS rooms CASCADE;
DROP TABLE IF EXISTS guests CASCADE;

-- Drop existing custom enum types
DROP TYPE IF EXISTS room_status_enum CASCADE;
DROP TYPE IF EXISTS booking_status_enum CASCADE;
DROP TYPE IF EXISTS payment_status_enum CASCADE;

-- =============================================================================
-- 1. ENUMERATED TYPES (Domain Constraints)
-- =============================================================================
CREATE TYPE room_status_enum AS ENUM ('available', 'occupied', 'maintenance');
CREATE TYPE booking_status_enum AS ENUM ('confirmed', 'checked_in', 'checked_out', 'cancelled');
CREATE TYPE payment_status_enum AS ENUM ('pending', 'completed', 'refunded');

-- =============================================================================
-- 2. TABLE CREATION WITH CONSTRAINTS
-- =============================================================================

-- 2.1 Guests Table
CREATE TABLE guests (
    guest_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2.2 Rooms Table
CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type VARCHAR(50) NOT NULL,
    daily_rate NUMERIC(10, 2) NOT NULL,
    status room_status_enum NOT NULL DEFAULT 'available',
    CONSTRAINT chk_positive_rate CHECK (daily_rate > 0)
);

-- 2.3 Bookings Table
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

-- 2.4 Payments Table
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

-- 2.5 Check-In / Check-Out Log Table
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
