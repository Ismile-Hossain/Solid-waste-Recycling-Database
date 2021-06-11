CREATE TABLE Error(
	process_date			DATE,
	process_id				VARCHAR2(15),
	error_id			    VARCHAR2(15),
	error_type				VARCHAR2(30),
	error_solving_cost		NUMBER(20,5) CHECK (error_solving_cost>0),
	employee_id 			VARCHAR2(20),
	
	CONSTRAINT ERR_p_id_dt_e_id_pk_fk
		PRIMARY KEY(process_date,process_id,employee_id),
		FOREIGN KEY(process_date,process_id)
			REFERENCES Recycling_Process (process_date,process_id)
			ON DELETE CASCADE,
		FOREIGN KEY (employee_id)
			REFERENCES Employee (employee_id) ON DELETE CASCADE
);

CREATE SEQUENCE error_sequence
INCREMENT BY 1
START WITH 10000002
MAXVALUE 99999999
NOCACHE
NOCYCLE;


INSERT INTO Error VALUES (TO_DATE('1-JAN-2019','DD-MON-YYYY'),'PROC_00000001','ERR_10000001','MACHINE ERROR',15000,'EMP_00000001');
INSERT INTO Error VALUES (TO_DATE('2-JAN-2019','DD-MON-YYYY'),'PROC_00000002',CONCAT('ERR_',CAST(ERROR_SEQUENCE.NEXTVAL AS VARCHAR2(15))),'MACHINE ERROR',20000,'EMP_00000002');
INSERT INTO Error VALUES (TO_DATE('3-JAN-2019','DD-MON-YYYY'),'PROC_00000003',CONCAT('ERR_',CAST(ERROR_SEQUENCE.NEXTVAL AS VARCHAR2(15))),'MACHINE ERROR',35000,'EMP_00000001');
