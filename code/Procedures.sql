DELIMITER //

CREATE PROCEDURE insert_reselling_ticket_proc(
   IN p_EAN BIGINT,
   OUT result_message VARCHAR(255)
)
BEGIN
  DECLARE v_event_id INT;
  DECLARE v_number_of_tickets INT;
  DECLARE v_stage_capacity INT;

  -- Find the event_id
  SELECT event_id INTO v_event_id FROM ticket WHERE EAN_13 = p_EAN;
  
  -- Count the tickets
  SELECT COUNT(*) INTO v_number_of_tickets FROM ticket WHERE event_id = v_event_id;

  -- Find the Stage Capacity
  SELECT s.stage_capacity INTO v_stage_capacity
  FROM event e
  JOIN stage s ON e.stage_id = s.stage_id
  WHERE e.event_id = v_event_id;

  -- Check if the stage is sold out 
  IF v_number_of_tickets < v_stage_capacity THEN
    SET result_message = 'Stage is not sold out. Cannot resell ticket.';
    INSERT INTO reselling_tickets (EAN_13) VALUES (p_EAN);
    SET result_message = CONCAT('Ticket added to reselling platform. Number of Tickets: ', v_number_of_tickets, ' - stage capacity: ', v_stage_capacity);
  END IF;
END //

DELIMITER ;