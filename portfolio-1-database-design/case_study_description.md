# Case Study Overview: Grand Vista Hotel Management System

## 1. System & Organisation Description
* **Organisation Name**: Grand Vista Hotel & Suites[cite: 2].
* **Nature of Business**: Grand Vista Hotel & Suites is a mid-sized commercial hospitality enterprise providing short-stay and extended-stay accommodations[cite: 2]. The database system centralizes online and front-desk reservations, manages physical room inventory across tiers, records financial transactions, and logs guest arrival/departure lifecycles in real time[cite: 2].

---

## 2. Primary Database Users & Access Roles
* **Front Desk Receptionists**: Execute day-to-day operations including looking up guest profiles, processing check-ins and check-outs, and updating physical room statuses[cite: 2].
* **Hotel Managers**: Monitor operational occupancy metrics, adjust seasonal room pricing, oversee room maintenance schedules, and generate financial summaries[cite: 2].
* **Guests (Self-Service Portal)**: Search real-time room availability, make advance bookings, view active reservations, and download transaction receipts[cite: 2].
* **Financial Auditors**: Review payment transaction logs, settle billing discrepancies, and verify daily revenue reconciliation reports[cite: 2].
* **System Administrators**: Manage database user roles, perform system backups, maintain data integrity constraints, and optimize server performance[cite: 2].

---

## 3. Major Stored Data
* **Guest Records**: Customer profiles containing full name, verified email address, contact phone number, and account creation timestamps[cite: 2].
* **Room Inventory**: Room identification, room numbers, room category (e.g., Standard, Deluxe, Suite), daily rental rates, and real-time operational status (e.g., Available, Occupied, Maintenance)[cite: 2].
* **Bookings & Reservations**: Detailed reservation logs linking guests to specific rooms, scheduled check-in and check-out dates, total cost calculations, and booking statuses (e.g., Confirmed, Checked-In, Checked-Out, Cancelled)[cite: 2].
* **Payment Transactions**: Payment settlement records including transaction amounts, payment methods (e.g., Credit Card, Cash, Bank Transfer), execution timestamps, and payment statuses (e.g., Pending, Completed, Refunded)[cite: 2].
* **Check-In / Check-Out Audit Logs**: Precise physical stay records tracking actual arrival timestamps, departure timestamps, key card issuance verification, and staff notes[cite: 2].

---

## 4. Key Operations Supported
* **Room Availability Search**: Real-time querying of unreserved rooms based on requested date ranges and room capacity[cite: 2].
* **Reservation Processing**: Atomic creation of new bookings with automated room availability status updates[cite: 2].
* **Payment Processing**: Recording payment transactions linked directly to booking IDs with status updates[cite: 2].
* **Guest Lifecycle Tracking**: Executing real-time check-in and check-out actions, automatically setting room availability to 'Occupied' or 'Available'[cite: 2].
* **Financial & Occupancy Analytics**: Generating audit reports on revenue generation, occupancy rates, and payment logs across specified date intervals[cite: 2].
