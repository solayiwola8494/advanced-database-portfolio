erDiagram
    GUESTS ||--o{ BOOKINGS : places
    ROOMS ||--o{ BOOKINGS : reserved_in
    BOOKINGS ||--o{ PAYMENTS : generates
    BOOKINGS ||--|| CHECK_IN_CHECK_OUT : logs

    GUESTS {
        int guest_id PK
        string first_name
        string last_name
        string email UK
        string phone_number
        datetime created_at
    }

    ROOMS {
        int room_id PK
        string room_number UK
        string room_type
        decimal daily_rate
        string status
    }

    BOOKINGS {
        int booking_id PK
        int guest_id FK
        int room_id FK
        date check_in_date
        date check_out_date
        decimal total_amount
        string status
        datetime created_at
    }

    PAYMENTS {
        int payment_id PK
        int booking_id FK
        decimal amount
        string payment_method
        string payment_status
        datetime payment_time
    }

    CHECK_IN_CHECK_OUT {
        int record_id PK
        int booking_id FK,UK
        datetime actual_check_in
        datetime actual_check_out
        boolean room_key_issued
        string notes
    }
