-- =============================================================================
-- Database Schema Script: Grand Vista Hotel Management System
-- Portfolio Component: Portfolio 1 - Database Design & Modelling
-- Target Database: PostgreSQL
-- Description: Creates custom enum types, core tables, primary keys, foreign keys, 
--              and domain constraints for room reservations, payments, and logs.
-- =============================================================================

-- Clean build: Drop existing tables if they exist to allow clean execution
DROP TABLE IF EXISTS check_in_check_out CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS rooms CASCADE;
DROP TABLE IF EXISTS guests CASCADE;

-- Drop existing custom enum data types
DROP TYPE IF EXISTS room_status_enum CASCADE;
DROP TYPE IF EXISTS booking_status_enum CASCADE;
DROP TYPE IF EXISTS payment_status_enum CASCADE;

-- =============================================================================
-- 1. ENUMERATED DATA TYPES (Restricted Domain Values)
-- =============================================================================

-- Defines operational statuses for physical hotel rooms
CREATE TYPE room_status_enum AS ENUM ('available', 'occupied', 'maintenance');

-- Defines lifecycle states for a guest booking
CREATE TYPE booking_status_enum AS ENUM ('confirmed', 'checked_in', 'checked_out', 'cancelled');

-- Defines financial settlement statuses for transactions
CREATE TYPE payment_status_enum AS ENUM ('pending', 'completed', 'refunded');

-- =============================================================================
-- 2. TABLE DEFINITIONS & CONSTRAINTS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Table: guests
-- Purpose: Stores profile and contact information for registered customers
-- -----------------------------------------------------------------------------
CREATE TABLE guests (
    guest_id SERIAL PRIMARY KEY,                    -- Auto-incrementing unique customer ID
    first_name VARCHAR(50) NOT NULL,               -- Guest given name
    last_name VARCHAR(50) NOT NULL,                -- Guest family name
    email VARCHAR(150) NOT NULL UNIQUE,            -- Unique contact/account email address
    phone_number VARCHAR(20) NOT NULL,             -- Contact phone number
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP -- Record creation timestamp
);

-- -----------------------------------------------------------------------------
-- Table: rooms
-- Purpose: Stores physical room inventory, room categories, and daily rates
-- -----------------------------------------------------------------------------
CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,                    -- Auto-incrementing internal room ID
    room_number VARCHAR(10) NOT NULL UNIQUE,       -- Public physical room number (e.g., '101A')
    room_type VARCHAR(50) NOT NULL,                -- Category (e.g., 'Standard', 'Deluxe', 'Suite')
    daily_rate NUMERIC(10, 2) NOT NULL,            -- Nightly rate in local currency
    status room_status_enum NOT NULL DEFAULT 'available', -- Real-time room status
    CONSTRAINT chk_positive_rate CHECK (daily_rate > 0)   -- Ensures pricing is always positive
);

-- -----------------------------------------------------------------------------
-- Table: bookings
-- Purpose: Records room reservations linking individual guests to specific rooms
-- -----------------------------------------------------------------------------
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,                  -- Auto-incrementing reservation ID
    guest_id INT NOT NULL,                         -- Foreign key referencing guests table
    room_id INT NOT NULL,                          -- Foreign key referencing rooms table
    check_in_date DATE NOT NULL,                   -- Scheduled arrival date
    check_out_date DATE NOT NULL,                  -- Scheduled departure date
    total_amount NUMERIC(10, 2) NOT NULL,          -- Total calculated reservation cost
    status booking_status_enum NOT NULL DEFAULT 'confirmed', -- Reservation lifecycle state
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Timestamp when booking was made
    
    -- Foreign key constraints preventing deletion of referenced entity records
    CONSTRAINT fk_booking_guest FOREIGN KEY (guest_id) 
        REFERENCES guests(guest_id) ON DELETE RESTRICT,
    CONSTRAINT fk_booking_room FOREIGN KEY (room_id) 
        REFERENCES rooms(room_id) ON DELETE RESTRICT,
        
    -- Check constraints validating logical dates and positive payment values
    CONSTRAINT chk_dates CHECK (check_out_date > check_in_date),
    CONSTRAINT chk_positive_total CHECK (total_amount >= 0)
);

-- -----------------------------------------------------------------------------
-- Table: payments
-- Purpose: Tracks monetary transactions associated with guest reservations
-- -----------------------------------------------------------------------------
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,                  -- Auto-incrementing payment ID
    booking_id INT NOT NULL,                       -- Foreign key referencing bookings table
    amount NUMERIC(10, 2) NOT NULL,                -- Monetary value paid
    payment_method VARCHAR(50) NOT NULL,           -- Payment channel (e.g., 'Credit Card', 'Cash')
    payment_status payment_status_enum NOT NULL DEFAULT 'pending', -- Transaction state
    payment_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,     -- Transaction execution time
    
    -- Cascades deletion if parent booking record is removed
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) 
        REFERENCES bookings(booking_id) ON DELETE CASCADE,
    CONSTRAINT chk_positive_payment CHECK (amount > 0) -- Validates payment value is positive
);

-- -----------------------------------------------------------------------------
-- Table: check_in_check_out
-- Purpose: Logs physical stay arrival and departure events for audit purposes
-- -----------------------------------------------------------------------------
CREATE TABLE check_in_check_out (
    record_id SERIAL PRIMARY KEY,                  -- Auto-incrementing audit log record ID
    booking_id INT NOT NULL UNIQUE,                -- Foreign key (1-to-1 relationship with bookings)
    actual_check_in TIMESTAMP NOT NULL,            -- Precise physical check-in timestamp
    actual_check_out TIMESTAMP,                    -- Precise physical check-out timestamp (nullable until departure)
    room_key_issued BOOLEAN NOT NULL DEFAULT TRUE, -- Key card issuance flag
    notes TEXT,                                    -- Optional receptionist notes or comments
    
    -- Cascades deletion if parent booking record is removed
    CONSTRAINT fk_log_booking FOREIGN KEY (booking_id) 
        REFERENCES bookings(booking_id) ON DELETE CASCADE
);
