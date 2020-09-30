/* Функция которая получает на вход номенклатурный номер прибора и дату его последней поверки.
 * Возвращает дату следующей поверки СИ в соответствии с принятым интервалом на производстве.
 */
DROP FUNCTION IF EXISTS f_next_calibration_date;
DELIMITER //
CREATE FUNCTION f_next_calibration_date(id_n_m_inst BIGINT, date_expl DATE)
RETURNS DATE READS SQL DATA
BEGIN
	DECLARE cal_int BIGINT;
	DECLARE next_cal DATE;

	SET cal_int = (SELECT accepted_calibration_interval FROM n_m_instruments WHERE id = id_n_m_inst);
	
	SET next_cal = date_expl + INTERVAL cal_int MONTH;
	
	RETURN next_cal;
END//
DELIMITER ;

-- date_exploitation + INTERVAL(f_calibration_interval(id_n_m_instruments)) MONTH

-- SELECT f_next_calibration_date('5', '2000-01-01');