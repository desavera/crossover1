# Create database

CREATE DATABASE airtsdev;

# Selecting database

USE airtsdev;

# Create schemas

# Create tables
CREATE TABLE IF NOT EXISTS reservation
(
    res_id BIGINT NOT NULL,
    reservation_owner BIGINT,
    reservation_state INT,
    reservation_schedule BIGINT,
    reservation_transaction BIGINT,
    reservation_number_of_seats INT,
    reservation_seats CHARACTER(250),
    PRIMARY KEY(res_id)
);

CREATE TABLE IF NOT EXISTS reservation_state
(
    state_id INT NOT NULL,
    next_state INT,
    previous_state INT,
    state_name CHARACTER(50),
    PRIMARY KEY(state_id)
);

CREATE TABLE IF NOT EXISTS reservation_owner
(
    owner_id BIGINT NOT NULL,
    owner_name CHARACTER(50),
    owner_passport_number CHARACTER(50),
    owner_email CHARACTER(50),
    PRIMARY KEY(owner_id)
);

CREATE TABLE IF NOT EXISTS reservation_schedule
(
    schedule_id BIGINT,
    schedule_timestamp DATE,
    schedule_departure_time DATE,
    schedule_origin INT,
    schedule_destiny INT,
    schedule_available_seats CHARACTER(250),
    schedule_timezone INT,
    schedule_arriving_estimate_time DATE    
);

CREATE TABLE IF NOT EXISTS reservation_spot
(
    spot_id INT NOT NULL,
    spot_name CHARACTER(50),
    spot_code CHARACTER(5),
    PRIMARY KEY(spot_id)
);

CREATE TABLE IF NOT EXISTS user_session
(
    session_id INT NOT NULL,
    auth_flag TINYINT(1),
    auth_broker INT,
    auth_broker_token_id BIGINT,
    reservation_owner BIGINT,
    session_start DATE,
    session_end DATE,
    PRIMARY KEY(session_id)
);

CREATE TABLE IF NOT EXISTS reservation_transaction
(
    transaction_id BIGINT NOT NULL,
    transaction_broker INT,
    transaction_broker_transaction_id BIGINT,
    PRIMARY KEY(transaction_id)
);

CREATE TABLE IF NOT EXISTS auth_broker
(
    broker_id INT NOT NULL,
    broker_name CHARACTER(50),
    PRIMARY KEY(broker_id)
);

CREATE TABLE IF NOT EXISTS owner_auth_broker_map
(
    broker_owner_id BIGINT NOT NULL,
    auth_broker INT,
    reservation_owner BIGINT,
    PRIMARY KEY(broker_owner_id)
);

CREATE TABLE IF NOT EXISTS reservation_message_log
(
    reservation BIGINT,
    message_delivery_status TINYINT(1),
    message_sent_timestamp DATE,
    message_type BIGINT    
);

CREATE TABLE IF NOT EXISTS reservation_message_type
(
    message_type_id BIGINT NOT NULL,
    message_type_name CHARACTER(50),
    PRIMARY KEY(message_type_id)
);


# Create FKs
ALTER TABLE reservation_state
    ADD    FOREIGN KEY (state_id)
    REFERENCES reservation_state(previous_state)
;
    
ALTER TABLE reservation
    ADD    FOREIGN KEY (reservation_owner)
    REFERENCES reservation_owner(owner_id)
;
    
ALTER TABLE reservation
    ADD    FOREIGN KEY (reservation_state)
    REFERENCES reservation_state(state_id)
;
    
ALTER TABLE reservation
    ADD    FOREIGN KEY (reservation_schedule)
    REFERENCES reservation_schedule(schedule_id)
;
    
ALTER TABLE reservation_schedule
    ADD    FOREIGN KEY (schedule_origin)
    REFERENCES reservation_spot(spot_id)
;
    
ALTER TABLE reservation_schedule
    ADD    FOREIGN KEY (schedule_destiny)
    REFERENCES reservation_spot(spot_id)
;
    
ALTER TABLE reservation_state
    ADD    FOREIGN KEY (state_id)
    REFERENCES reservation_state(next_state)
;
    
ALTER TABLE reservation
    ADD    FOREIGN KEY (reservation_transaction)
    REFERENCES reservation_transaction(transaction_id)
;
    
ALTER TABLE user_session
    ADD    FOREIGN KEY (auth_broker)
    REFERENCES auth_broker(broker_id)
;
    
ALTER TABLE user_session
    ADD    FOREIGN KEY (reservation_owner)
    REFERENCES reservation_owner(owner_id)
;
    
ALTER TABLE owner_auth_broker_map
    ADD    FOREIGN KEY (auth_broker)
    REFERENCES auth_broker(broker_id)
;
    
ALTER TABLE owner_auth_broker_map
    ADD    FOREIGN KEY (reservation_owner)
    REFERENCES reservation_owner(owner_id)
;
    
ALTER TABLE reservation_message_log
    ADD    FOREIGN KEY (reservation)
    REFERENCES reservation(res_id)
;
    
ALTER TABLE reservation_message_log
    ADD    FOREIGN KEY (message_type)
    REFERENCES reservation_message_type(message_type_id)
;
    


