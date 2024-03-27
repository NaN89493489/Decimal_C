-- CREATE DATABASE "SQL3_RetailAnalitycs_v1.0"

create table if not EXISTS Personal_information( 
  Customer_ID serial primary key not null,
  Customer_Name varchar,
  Customer_Surname varchar,
  Customer_Primary_Email varchar,
  Customer_Primary_Phone varchar,
  CONSTRAINT ch_customer_customer_name CHECK (Customer_Name ~ '^[A-Z|А-Я]{1}[a-z|а-я\- ]*$'),
  CONSTRAINT ch_customer_customer_surname CHECK (Customer_Surname ~ '^[A-Z|А-Я]{1}[a-z|а-я\- ]*$'),
  CONSTRAINT ch_customer_primary_email CHECK (Customer_Primary_Email ~ '^[A-Z|А-Я|a-z|а-я|0-9\-_.]*[@]{1}[a-z|а-я\-.]*$'),
  CONSTRAINT ch_customer_primary_phone CHECK (Customer_Primary_Phone ~ '^[+]{1}[7]{1}[0-9]{10}$')
);

create table if not EXISTS Cards( 
  Customer_Card_ID serial primary key not null,
  Customer_ID bigint not null,
  CONSTRAINT fk_cards_personal_information FOREIGN KEY (Customer_ID) REFERENCES Personal_information(Customer_ID)
);

create table if not EXISTS SKU_group( 
  Group_ID serial primary key not null,
  Group_Name varchar not null,
  CONSTRAINT ch_SKU_group_group_name CHECK  (Group_Name ~ '^[A-Z|a-z|А-Я|а-я|0-9|[:punct:]\ ]*$')
);

create table if not EXISTS Product_grid( 
  SKU_ID serial primary key not null,
  SKU_Name varchar,
  Group_ID bigint,
  CONSTRAINT fk_product_grid_group_ID FOREIGN KEY (Group_ID) REFERENCES SKU_group(Group_ID),
  CONSTRAINT ch_product_grid_SKU_name CHECK  (SKU_Name ~ '^[A-Z|a-z|А-Я|а-я|0-9|[:punct:]\ ]*$')
);

create table if not EXISTS Stores( 
  Transaction_Store_ID bigint not null,
  SKU_ID bigint not null,
  SKU_Purchase_Price numeric not null,
  SKU_Retail_Price numeric not null,
  CONSTRAINT fk_stores_product_grid FOREIGN KEY (SKU_ID) REFERENCES Product_grid (SKU_ID)
);

create table if not EXISTS Transactions( 
  Transaction_ID  serial primary key not null,
  Customer_Card_ID bigint not null,
  Transaction_Summ numeric not null,
  Transaction_DateTime timestamp  not null,
  Transaction_Store_ID bigint not null,
  CONSTRAINT fk_transactions_cards FOREIGN KEY (Customer_Card_ID) REFERENCES Cards(Customer_Card_ID)
);

create table if not EXISTS Checks( 
  Transaction_ID bigint not null,
  SKU_ID bigint not null,
  SKU_Amount numeric not null,
  SKU_Summ numeric not null,
  SKU_Summ_Paid numeric not null,
  SKU_Discount numeric not null,
  CONSTRAINT fk_checks_transaction_ID FOREIGN KEY (Transaction_ID) REFERENCES Transactions (Transaction_ID),
  CONSTRAINT fk_checks_SKU_ID  FOREIGN KEY (SKU_ID) REFERENCES Product_grid (SKU_ID)
);

create table if not EXISTS Date_of_analysis_formation( 
  Analysis_Formation timestamp not null
);





-----------------------------------------------------import&export----------------------------------------------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE import_from_csv(p_table_name VARCHAR, p_file_path VARCHAR, p_separator VARCHAR)
AS
$$
BEGIN
    EXECUTE FORMAT('COPY %I FROM %L WITH (FORMAT TEXT, DELIMITER %L)', p_table_name, p_file_path, p_separator);
END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE import_from_tsv(p_table_name VARCHAR, p_file_path VARCHAR)
AS
$$
BEGIN
    SET datestyle = 'ISO, DMY';
    EXECUTE FORMAT('COPY %I FROM %L WITH (FORMAT TEXT, DELIMITER E''\t'')', p_table_name, p_file_path);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE export_to_csv(p_table_name VARCHAR, p_file_path VARCHAR)
AS
$$
BEGIN
    EXECUTE FORMAT('COPY %I TO %L WITH (FORMAT CSV)', p_table_name, p_file_path);
END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE export_to_tsv(p_table_name VARCHAR, p_file_path VARCHAR)
AS
$$
BEGIN
    EXECUTE FORMAT('COPY %I TO %L WITH (FORMAT TEXT)', p_table_name, p_file_path);
END
$$ LANGUAGE plpgsql;




------------------------------------------------------------------------------------------------------------------------------------------------------------
--mini

  -- CALL import_from_tsv( 'personal_information', 'C:\sql\SQL3_RetailAnalitycs_v1.0-1\datasets\Personal_Data_Mini.tsv');
  -- CALL import_from_tsv('cards', 'C:\sql\SQL3_RetailAnalitycs_v1.0-1\datasets\Cards_Mini.tsv');
  -- CALL import_from_tsv('sku_group', 'C:\sql\SQL3_RetailAnalitycs_v1.0-1\datasets\Groups_SKU_Mini.tsv');
  -- CALL import_from_tsv('product_grid', 'C:\sql\SQL3_RetailAnalitycs_v1.0-1\datasets\SKU_Mini.tsv');
  -- CALL import_from_tsv('stores', 'C:\sql\SQL3_RetailAnalitycs_v1.0-1\datasets\Stores_Mini.tsv');
  -- CALL import_from_tsv('transactions', 'C:\sql\SQL3_RetailAnalitycs_v1.0-1\datasets\Transactions_Mini.tsv');
  -- CALL import_from_tsv('checks', 'C:\sql\SQL3_RetailAnalitycs_v1.0-1\datasets\Checks_Mini.tsv');
  -- CALL import_from_tsv('date_of_analysis_formation', 'C:\sql\SQL3_RetailAnalitycs_v1.0-1\datasets\Date_Of_Analysis_Formation.tsv');
