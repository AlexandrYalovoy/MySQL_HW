DROP DATABASE IF EXISTS kurs_base_YA;
CREATE DATABASE kurs_base_YA;
USE kurs_base_YA;


DROP TABLE IF EXISTS divisions_company;
CREATE TABLE divisions_company(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'Шифр подразделения',
	short_name VARCHAR(10) UNIQUE COMMENT 'Краткое имя подразделения',
	full_name VARCHAR(80) UNIQUE COMMENT 'Полное имя подразделения',
	region VARCHAR(50) COMMENT 'Регион подразделения',
	city VARCHAR(255) COMMENT 'Город',
	adress VARCHAR(255) COMMENT 'Юридический адрес подраздлеления',
	telephone VARCHAR(80) COMMENT 'Телефон',
	note TEXT COMMENT 'Примечание'
	) COMMENT = 'Таблица которая содержит общую информацию о подразделениях';


DROP TABLE IF EXISTS workshops_divisions;
CREATE TABLE workshops_divisions(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'Шифр цеха',
	id_divisions BIGINT UNSIGNED COMMENT 'Шифр подразделения связанный с divisions_company.id',
	short_name VARCHAR(10) COMMENT 'Краткое имя цеха',
	full_name VARCHAR(80) COMMENT 'Полное имя цеха',
	location VARCHAR(255) COMMENT 'Место нахождения АБК цеха',
	telephone VARCHAR(80) COMMENT 'Телефон',
	note TEXT COMMENT 'Примечание',
	
	FOREIGN KEY (id_divisions) REFERENCES divisions_company(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
	
	) COMMENT = 'Таблица которая содержит общую информацию о цехах';


DROP TABLE IF EXISTS staff;
CREATE TABLE staff(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'Табельный номер',
	status ENUM('В работе', 'Уволен') DEFAULT 'В работе',
	id_workshop BIGINT UNSIGNED COMMENT 'Цех',
	last_name VARCHAR(80) COMMENT 'Фамилия',
	first_name VARCHAR(80) COMMENT 'Имя',
	patronymic VARCHAR(80) COMMENT 'Отчество',
	`position` VARCHAR(150) COMMENT 'Должность',
	telephone VARCHAR(80) COMMENT 'Телефон',
	e_mail VARCHAR(80) UNIQUE COMMENT 'e-mail',
	employment_date DATE COMMENT 'Дата вступления в должность',
	experience_position VARCHAR(10) DEFAULT(TIMESTAMPDIFF(YEAR, employment_date, NOW())) COMMENT 'Опыт в должностиб лет',
	employment_company DATE COMMENT 'Дата трудоустройства',
	experience_company VARCHAR(10) DEFAULT(TIMESTAMPDIFF(YEAR, employment_company, NOW())) COMMENT 'Опыт в компании, лет',
	note TEXT COMMENT 'Примечание',
	
	FOREIGN KEY (id_workshop) REFERENCES workshops_divisions(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
	
	) COMMENT = 'Таблица которая содержит общую информацию о сотрудниках компании';


DROP TABLE IF EXISTS n_m_instruments;
CREATE TABLE n_m_instruments(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'Номенклотурный номер',
	short_name VARCHAR(100) COMMENT 'Краткое имя прибора',
	full_name VARCHAR(255) COMMENT 'Полное имя прибора',
	accuracy_class VARCHAR(100) COMMENT 'Класс точности/Погрешность',
	measuring_range VARCHAR(100) COMMENT 'Диапазон измерения',
	factory_calibration_interval TINYINT UNSIGNED COMMENT 'Интервал поверки установленный заводом ихготовителем в месяцах',
	accepted_calibration_interval TINYINT UNSIGNED DEFAULT (factory_calibration_interval) COMMENT 'Интервал поверки принятый на производстве в месяцах',
	manufacturing_plant VARCHAR(100) COMMENT 'Наименование завода изготовителя',
	note TEXT COMMENT 'Примечание'
	
	)COMMENT = 'Таблица которая содержит номенклатуру применяемых на произвосдтве средств измерения';


DROP TABLE IF EXISTS m_i_exploitation;
CREATE TABLE m_i_exploitation(
	id BIGINT UNSIGNED PRIMARY KEY COMMENT 'id прибора как единицы',
	id_n_m_instruments BIGINT UNSIGNED COMMENT 'Номенклотурный номер прибора связанный с n_m_instruments.id',
	serial_number VARCHAR(100) UNIQUE COMMENT 'Серийный номер прибора',
	workshop_installation BIGINT UNSIGNED COMMENT 'Шифр цеха установки связанный с workshops_divisions.id',
	point_installation VARCHAR(100) COMMENT 'Конкретная точка установки',
	date_exploitation DATE COMMENT 'Дата ввода в эксплуатацию',
	last_calibration_date DATE DEFAULT NULL COMMENT 'Дата последней поверки',
	next_calibration_date DATE DEFAULT NULL COMMENT 'Дата следующей поверки',
	materially_responsible_person BIGINT UNSIGNED COMMENT 'Табельный номер материально ответсвенного лица связанный с staff.id',
	note TEXT COMMENT 'Примечание',
	
	FOREIGN KEY (id_n_m_instruments) REFERENCES n_m_instruments(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	FOREIGN KEY (workshop_installation) REFERENCES workshops_divisions(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	FOREIGN KEY (materially_responsible_person) REFERENCES staff(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
	
	) COMMENT = 'Таблица которая содержит информацию о СИ находящихся в эксплуатации';


DROP TABLE IF EXISTS m_i_decommissioned;
CREATE TABLE m_i_decommissioned(
	id BIGINT UNSIGNED PRIMARY KEY COMMENT 'id прибора как единицы',
	id_n_m_instruments BIGINT UNSIGNED COMMENT 'Номенклотурный номер прибора связанный с n_m_instruments.id',
	serial_number VARCHAR(100) UNIQUE COMMENT 'Серийный номер прибора',
	date_exploitation DATE COMMENT 'Дата ввода в эксплуатацию',
	date_decommissioned DATE COMMENT 'Дата списания',
	act_decommissioned VARCHAR(100) COMMENT 'Номер и дата Акта списания',
	past_workshop_installation BIGINT UNSIGNED COMMENT 'Шифр цеха последней установки связанный с workshops_divisions.id',
	past_point_installation VARCHAR(100) COMMENT 'Последня точка установки',
	note TEXT COMMENT 'Примечание',
	
	FOREIGN KEY (id_n_m_instruments) REFERENCES n_m_instruments(id)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION,
	
	FOREIGN KEY (past_workshop_installation) REFERENCES workshops_divisions(id)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
	
	) COMMENT = 'Таблица которая содержит информацию о списанных СИ';


DROP TABLE IF EXISTS metrological_service;
CREATE TABLE metrological_service(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'id обслуживания',
	id_instrument BIGINT UNSIGNED COMMENT 'id прибора как единицы',
	serial_number VARCHAR(100) UNIQUE COMMENT 'Серийный номер прибора',
	id_n_m_instruments BIGINT UNSIGNED COMMENT 'Номенклотурный номер прибора связанный с n_m_instruments.id',
	status ENUM('Отправлен', 'Принят', 'В работе', 'Готов', 'Подлежит списанию'),
	date_receipt_мetrology DATE COMMENT 'Дата поступления в метрологию',
	date_completed_calibration DATE COMMENT 'Дата выполнения поверки',
	past_workshop_installation BIGINT UNSIGNED COMMENT 'Шифр цеха последней установки связанный с workshops_divisions.id',
	past_point_installation VARCHAR(100) COMMENT 'Последня точка установки',
	materially_responsible_person BIGINT UNSIGNED COMMENT 'Табельный номер материально ответсвенного лица связанный с staff.id',
	workshop_мetrology BIGINT UNSIGNED COMMENT 'Шифр цеха метрологической службы с workshops_divisions.id',
	мetrology_engineer BIGINT UNSIGNED COMMENT 'Табельный номер инженера метрологии который производит обслуживание с staff.id',
	note TEXT COMMENT 'Примечание',
	
	FOREIGN KEY (id_n_m_instruments) REFERENCES n_m_instruments(id)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION,
	
	FOREIGN KEY (past_workshop_installation) REFERENCES workshops_divisions(id)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION,
	
	FOREIGN KEY (materially_responsible_person) REFERENCES staff(id)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION,
	
	FOREIGN KEY (workshop_мetrology) REFERENCES workshops_divisions(id)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION,
	
	FOREIGN KEY (мetrology_engineer) REFERENCES staff(id)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
	
	) COMMENT = 'Таблица которая содержит информацию о передаваемых средствах в метрологию и их статусе';


DROP TABLE IF EXISTS warehouse_availability;
CREATE TABLE warehouse_availability(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'id прибора как единицы',
	id_n_m_instruments BIGINT UNSIGNED COMMENT 'Номенклотурный номер прибора связанный с n_m_instruments.id',
	serial_number VARCHAR(100) UNIQUE COMMENT 'Серийный номер прибора',
	workshop_installation BIGINT UNSIGNED COMMENT 'Шифр склада/цеха с workshops_divisions.id',
	date_receipt DATE COMMENT 'Дата поступления',
	input_calibration_date DATE DEFAULT NULL COMMENT 'Дата входной поверки',
	materially_responsible_person BIGINT UNSIGNED COMMENT 'Табельный номер материально ответсвенного лица связанный с staff.id',
	note TEXT COMMENT 'Примечание',
	
	FOREIGN KEY (id_n_m_instruments) REFERENCES n_m_instruments(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	FOREIGN KEY (workshop_installation) REFERENCES workshops_divisions(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	FOREIGN KEY (materially_responsible_person) REFERENCES staff(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
	
	) COMMENT = 'Таблица которая содержит информацию о запасах на складахы';


DROP TABLE IF EXISTS request_purchase;
CREATE TABLE request_purchase(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'id закупки',
	id_n_m_instruments BIGINT UNSIGNED COMMENT 'Номенклотурный номер прибора связанный с n_m_instruments.id',
	workshop_request BIGINT UNSIGNED COMMENT 'Цех заявитель связанный с workshops_divisions.id',
	status ENUM('В закупке', 'Отправлен на склад', 'Исполнено', 'Отказ'),
	note TEXT COMMENT 'Примечание',
	
	FOREIGN KEY (id_n_m_instruments) REFERENCES n_m_instruments(id)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION,
	
	FOREIGN KEY (workshop_request) REFERENCES workshops_divisions(id)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
	
	) COMMENT = 'Таблица которая содержит информацию о СИ в закупке';


DROP TABLE IF EXISTS application_use;
CREATE TABLE application_use(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'id заявки на применение',
	number_innovation_offer VARCHAR(100) UNIQUE COMMENT 'Номер рационализаторского предложения',
	status ENUM('На рассмотрении', 'Принято', 'Отправлено на доработку', 'Отказ'),
	initiator_offer BIGINT UNSIGNED COMMENT 'Табельный номер автора рационализаторского предложения связанное с staff.id',
	text_offer TEXT COMMENT 'Текст предложения',
	note TEXT COMMENT 'Примечание',
	
	FOREIGN KEY (initiator_offer) REFERENCES staff(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
	
	) COMMENT = 'Таблица которая содержит информацию о заявке на применение оборудования согласно предложениям';

