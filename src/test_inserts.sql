insert into personal_information(Customer_Name, Customer_Surname, Customer_Primary_Email, Customer_Primary_Phone) values 
('Лев',	'Цирюльников',	'hihaf439jokerfhhb71@ya.ru', '+79005457407'),
('Николай',	'Лаврентьев',	'714mexican732@mail.ru'	, '+74911741649'),
('Ганс',	'Варенников',	'icbfb53hackeriigac@mail.ru',	'+74820550118'),
('Войцех',	'Тимчук',	'83-camper9@mail.ru',	'+74821122627'),
('Андрей',	'Матюков',	'2jokercfaa296@mail.ru',	'+79161998657');

--insert into personal_information(Customer_Name, Customer_Surname, Customer_Primary_Email, Customer_Primary_Phone) values ('Лев',	'Иванов',	'hihaf439jokerfhhb71@ya.ru', '09005457407');
--insert into personal_information(Customer_Name, Customer_Surname, Customer_Primary_Email, Customer_Primary_Phone) values ('Лев',	'Иванов',	'hihaf439jokerfhhb71yaru', '+79005457407');
--insert into personal_information(Customer_Name, Customer_Surname, Customer_Primary_Email, Customer_Primary_Phone) values ('ЛЕВ',	'Иванов',	'hihaf439jokerfhhb71@ya.ru', '+79005457407');

insert into cards(Customer_ID) values 
(1),
(2),
(2),
(3),
(4),
(5);

insert into SKU_group(Group_Name) values 
('Аптека'),
('Молоко'),
('Автомобили'),
('Шоколад'),
('Пиво');

-- insert into SKU_group(Group_Name) values ('把');

insert into Product_grid(SKU_Name, Group_ID) values 
('Uzuma-Kolberg Анальгин Ромашка',	1),
('ОАО РосМосГосТорг Анальгин Shadow',	1),
('ОАО РосМосГосТорг Парацетамол Amnezia',	1),
('Kerton Молоко Red Line',	2),
('Kerton Молоко Ревалон',	2),
('ООО Леторг Молоко James Bondski',	2),
('Leizein Масло машинное James Bondski',	3),
('Heipz GmbH Мотоцикл James Bondski',	3),
('ОАО РосМосГосТорг Бензин АИ-95 Поездка',	3),
('Leizein Шоколадка Leta',	4),
('Uzuma-Kolberg Конфеты шоколадные James Bondski',	4),
('Heipz GmbH Пиво Жигули барное Ревалон',	5),
('ОАО РосМосГосТорг Пиво Жигули барное Перископ',	5);

-- insert into Product_grid(SKU_Name, Group_ID) values ('摹',	1);

insert into Stores(Transaction_Store_ID, SKU_ID, SKU_Purchase_Price, SKU_Retail_Price) values 
(1,	1,	'88.7968052457072',	'137.77440630484'),
(1,	2,	'77.3608189124432',	'152.667755664182'),
(1,	3,	'49.3678959092907',	'93.6595883820083'),
(2,	4,	'142.671663750741',	'256.400087567142'),
(2,	5,	'101.305311897446',	'118.922946390275'),
(2,	6,	'146.791639762368',	'216.584703667579'),
(2,	10,	'78.112903790601',	'89.9445273965629'),
(2,	11,	'169.639649351891',	'256.836444780339'),
(2,	12,	'126.424810724996',	'163.390304628555'),
(2,	13,	'64.7726266383066',	'111.190197591819'),
(3,	7,	'211.18888648096', 	'352.750717955538'),
(3,	8,	'476.771947909506',	'660.633594849607'),
(3,	9,	'364.414649801056',	'522.693772114499'),
(4, 4,  '104.143813584067',	'107.878841498674'),
(4, 6,  '129.87583016645',	'161.370973449813'),
(4, 10, '110.495326461035',	'208.88640560141'),
(5, 10, '85.1903935648456',	'144.292415423655'),
(5, 12, '155.968733387985',	'220.408887733089'),
(5, 5,  '101.305311897446',	'132.026180437647');

-- insert into Stores(Transaction_Store_ID, SKU_ID, SKU_Purchase_Price, SKU_Retail_Price) values (1,	1,	'88.7968052457072',	'137,77440630484');
-- insert into Stores(Transaction_Store_ID, SKU_ID, SKU_Purchase_Price, SKU_Retail_Price) values (1,	1,	'88.7968052457072',	'137.77440684увув');
-- insert into Stores(Transaction_Store_ID, SKU_ID, SKU_Purchase_Price, SKU_Retail_Price) values (1,	100,	'88.7968052457072',	'137.77440684');

insert into Transactions(Customer_Card_ID, Transaction_Summ, Transaction_DateTime, Transaction_Store_ID) values 
(4,	'458.003267',	'20.04.2019 20:12:48',	1),  -- 2*3                     
(1,	'364.7012093',	'08.11.2019 12:35:55',	5),  --10+12                  
(5,	'375.3229977',	'30.01.2019 12:09:08',	2),  --4+5                    
(2,	'1536.073033',	'13.04.2019 20:00:49',  3),  --8+9+7                  
(3,	'208.8864056',  '17.02.2019 19:56:10',	4),  --10                     
(5,	'705.5014360',  '08.10.2019 16:04:25',	3),  --7*2                    
(6,	'216.5847036',	'22.01.2020 13:18:45',	2),  --6                      
(1,	'454.430597',	'20.07.2019 23:56:29',	2);  --6+5*2

--insert into Transactions(Customer_Card_ID, Transaction_Summ, Transaction_DateTime, Transaction_Store_ID) values (4,	'458,003267',	'20.04.2019 21:12:48',	1);
--insert into Transactions(Customer_Card_ID, Transaction_Summ, Transaction_DateTime, Transaction_Store_ID) values (4,	'458.вккукук003267',	'20.05.2019 20:12:48',	1);
--insert into Transactions(Customer_Card_ID, Transaction_Summ, Transaction_DateTime, Transaction_Store_ID) values (400,	'458.003267',	'20.05.2019 20:12:48',	1);

insert into Checks(Transaction_ID, SKU_ID, SKU_Amount, SKU_Summ, SKU_Summ_Paid, SKU_Discount) values 
(1,	2, '3', '458.003267', '100',	'358.003267'),  
(2,	10, '1', '144.2924156', '44',	'100.2924156'),  
(2,	12, '1', '220.4088877', '60',	'160.4088877'), 
(3,	4, '1',  '256.4000875', '56',	'200.4000875'),  
(3,	5, '1', '118.9229463', '18',	'100.9229463'),  
(4,	7, '1', '352.7507179', '52',	'300.7507179'),  
(4,	8, '1', '660.6335948', '60',	'600.6335948'),  
(4,	9, '1', '522.6937721', '22',	'500.6937721'),  
(5,	10, '1', '208.8864056', '8.8864056',	'200'), 
(6,	7, '2', '705.5014360', '5.5014360',	'700'),
(7,	6, '1', '216.5847036', '16.5847036',	'200'),
(8,	6, '1', '216.5847036', '16.5847036',	'200'),
(8,	5, '2', '237.845893', '17',	'220.845893');

-- insert into Checks(Transaction_ID, SKU_ID, SKU_Amount, SKU_Summ, SKU_Summ_Paid, SKU_Discount) values (1,	2, '3', '458.003267', '100',	'358,003267'); 
-- insert into Checks(Transaction_ID, SKU_ID, SKU_Amount, SKU_Summ, SKU_Summ_Paid, SKU_Discount) values (1,	2, '3', '458.003267', '100',	'358,0вуу03267'); 
-- insert into Checks(Transaction_ID, SKU_ID, SKU_Amount, SKU_Summ, SKU_Summ_Paid, SKU_Discount) values (1,	200, '3', '458.003267', '100',	'358.03267'); 
-- insert into Checks(Transaction_ID, SKU_ID, SKU_Amount, SKU_Summ, SKU_Summ_Paid, SKU_Discount) values (100,	2, '3', '458.003267', '100',	'358.03267'); 




