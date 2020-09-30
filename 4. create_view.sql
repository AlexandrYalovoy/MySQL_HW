USE kurs_base_YA;

-- Представление которое показывает все СИ в эксплуатации на ЦППН НГДУ "НСН"
DROP VIEW IF EXISTS m_i_exp_cppn_nsn;
CREATE VIEW m_i_exp_cppn_nsn AS
	SELECT 
		m_i_exploitation.serial_number AS 'Серийный номер',
		m_i_exploitation.id_n_m_instruments AS 'Ном. номер СИ',
		n_m_instruments.short_name AS 'Название СИ',
		divisions_company.short_name AS 'Подразделение', 
		workshops_divisions.short_name AS 'ЦЕХ',
		m_i_exploitation.point_installation AS 'Место установки', 
		m_i_exploitation.date_exploitation AS 'Дата ввода в экспл.', 
		m_i_exploitation.last_calibration_date AS 'Дата поверки',
		m_i_exploitation.next_calibration_date AS 'Дата следующей поверки', 
		m_i_exploitation.materially_responsible_person AS 'Табельный номер МОЛ',
		CONCAT(staff.last_name, ' ', staff.first_name, ' ', staff.patronymic) AS 'ФИО МОЛ',
		staff.telephone AS 'Телефон МОЛ', 
		m_i_exploitation.note AS 'Примечание'
	FROM 
		m_i_exploitation
		JOIN
		divisions_company
		JOIN
		n_m_instruments
		JOIN
		staff
		JOIN
		workshops_divisions 
			ON 
			m_i_exploitation.workshop_installation = 34 
				AND 
			workshops_divisions.id = 34
				AND 
			divisions_company.id = 5 
				AND 
			n_m_instruments.id = m_i_exploitation.id_n_m_instruments
				AND
			m_i_exploitation.materially_responsible_person = staff.id; 


-- Представление которое показывает все СИ в эксплуатации НГДУ "НСН"
DROP VIEW IF EXISTS m_i_exp_nsn;
CREATE VIEW m_i_exp_nsn AS
	SELECT 
		m_i_exploitation.serial_number AS 'Серийный номер',
		m_i_exploitation.id_n_m_instruments AS 'Ном. номер СИ',
		n_m_instruments.short_name AS 'Название СИ',
		divisions_company.short_name AS 'Подразделение', 
		workshops_divisions.short_name AS 'ЦЕХ',
		m_i_exploitation.point_installation AS 'Место установки', 
		m_i_exploitation.date_exploitation AS 'Дата ввода в экспл.', 
		m_i_exploitation.last_calibration_date AS 'Дата поверки',
		m_i_exploitation.next_calibration_date AS 'Дата следующей поверки', 
		m_i_exploitation.materially_responsible_person AS 'Табельный номер МОЛ',
		CONCAT(staff.last_name, ' ', staff.first_name, ' ', staff.patronymic) AS 'ФИО МОЛ',
		staff.telephone AS 'Телефон МОЛ', 
		m_i_exploitation.note AS 'Примечание'
	FROM 
		m_i_exploitation
		JOIN
		divisions_company
		JOIN
		n_m_instruments
		JOIN
		staff
		JOIN
		workshops_divisions 
			ON 
			m_i_exploitation.workshop_installation IN (SELECT id FROM workshops_divisions WHERE id_divisions = 5) 
				AND 
			workshops_divisions.id IN (SELECT id FROM workshops_divisions WHERE id_divisions = 5) 
				AND 
			divisions_company.id = 5 
				AND 
			n_m_instruments.id = m_i_exploitation.id_n_m_instruments
				AND
			m_i_exploitation.materially_responsible_person = staff.id
				AND
			workshops_divisions.id = m_i_exploitation.workshop_installation;

