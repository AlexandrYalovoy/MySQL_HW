/*Триггеры которые обнавляют значение следующей даты калибровки (m_i_exploitation.next_calibration_date) при вставке и обнавлении
 * используют функцию f_next_calibration_date
 */

DROP TRIGGER IF EXISTS t_bi_next_calibration_date;
DELIMITER //
CREATE TRIGGER t_bi_next_calibration_date BEFORE INSERT ON m_i_exploitation
FOR EACH ROW 
BEGIN 
	SET NEW.next_calibration_date = f_next_calibration_date(NEW.id_n_m_instruments, NEW.last_calibration_date);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS t_bu_next_calibration_date;
DELIMITER //
CREATE TRIGGER t_bu_next_calibration_date BEFORE UPDATE ON m_i_exploitation
FOR EACH ROW 
BEGIN 
	SET NEW.next_calibration_date = f_next_calibration_date(NEW.id_n_m_instruments, NEW.last_calibration_date);
END//
DELIMITER ;