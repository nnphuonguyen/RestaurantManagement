--DROP table NguoiDung;
--Tao bang NguoiDung
create table Userr(
    ID_User NUMBER(8,0),
    Email varchar2(50),
    Password varchar2(20),
    VerifyCode varchar2(10)DEFAULT NULL,
    Status varchar2(10) DEFAULT '',
    Role varchar2(20)
);
---Them rang buoc
alter table Userr
    add constraint ND_Email_NNULL check ('Email' is not null)
    add constraint ND_Matkhau_NNULL check ('Password' is not null)
    add constraint ND_Vaitro_Ten check (Role in ('Customer','Employee','Employee House','Manager'));

---Them khoa chinh
alter table Userr
    add constraint NguoiDung_PK PRIMARY KEY (ID_User);
    
--Tao bang NhanVien
--drop table NhanVien;
create table Employees(
    ID_Emp NUMBER(8,0),
    NameEmp VARCHAR2(50),
    DateW DATE ,
    PhoneNum VARCHAR2(50),
    Position VARCHAR2(50),
    ID_User NUMBER(8,0) DEFAULT NULL,
    ID_Manager NUMBER(8,0),
    Status VARCHAR2(20)
);
--Them rang buoc cho bang NhanVien
--Them Check Constraint
alter table Employees
    add constraint NV_TenNV_NNULL check ('NameEmp' is not null)
    add constraint NV_SDT_NNULL check ('PhoneNum' is not null)
    add constraint NV_NgayVL_NNULL check ('DateW' is not null)
    add constraint NV_Chucvu_Thuoc check (Position IN ('Serve','Reception','Cashier','Kitchen','House','Manager'))
    add constraint NV_Tinhtrang_Thuoc check (Status IN ('Working','Has retired'));

--Them khoa chinh
alter table Employees
    add constraint NV_PK PRIMARY KEY (ID_Emp);

--Them khoa ngoai
ALTER TABLE Employees
 ADD CONSTRAINT NV_fk_idND FOREIGN KEY 
 (ID_User) REFERENCES Userr(ID_User)
 ADD CONSTRAINT NV_fk_idNQL FOREIGN KEY 
 (ID_Manager) REFERENCES Employees(ID_Emp);
 

--Tao bang KhachHang
--drop table KhachHang;
create table Customer(
    ID_Cus NUMBER(8,0),
    NameCus varchar2(50), 
    DateJ date, 
    Sales number(10,0) DEFAULT 0, 
    AccumulatedPoin number(5,0) DEFAULT 0,
    ID_User NUMBER(8,0)
);
--Them Check Constraint
alter table Customer
    add constraint KH_TenKH_NNULL check ('NameCus' is not null)
    add constraint KH_Ngaythamgia_NNULL check ('DateJ' is not null)
    add constraint KH_Doanhthu_NNULL check ('Sales' is not null)
    add constraint KH_Diemtichluy_NNULL check ('AccumulatedPoin' is not null)
    add constraint KH_IDND_NNULL check ('ID_User' is not null);

---Them khoa chinh
alter table Customer
    add constraint KhachHang_PK PRIMARY KEY (ID_Cus);
    
---Them khoa ngoai
ALTER TABLE Customer
 ADD CONSTRAINT KH_fk_idND FOREIGN KEY 
 (ID_User) REFERENCES Userr(ID_User);

--Tao bang MonAn
--drop table MonAn;
create table Dish(
    ID_Dish NUMBER(8,0),
    DishName varchar2(50), 
    Price number(8,0),
    TypeD varchar2(50),
    Status varchar2(30)
);
--Them Check Constraint
alter table Dish
    add constraint MA_TenMon_NNULL check ('DishName' is not null)
    add constraint MA_DonGia_NNULL check ('Price' is not null)
    add constraint MA_Loai_Ten check (TypeD in ('Aries','Taurus','Gemini','Cancer','Leo','Virgo'
                                                 ,'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces'))
    add constraint MA_TrangThai_Thuoc check (Status in('are trading','stop business'));                                             

--Them khoa chinh
alter table Dish
    add constraint MonAn_PK PRIMARY KEY (ID_Dish);


--Tao bang Ban
--drop table Ban;
create table Tablee(
    ID_Table NUMBER(8,0),
    TableName varchar2(50), 
    Locationn varchar2(50), 
    Status varchar2(50)
);
--Them Check Constraint
alter table Tablee
    add constraint Ban_TenBan_NNULL check ('TableName' is not null)
    add constraint Ban_Vitri_NNULL check ('Locationn' is not null)
    add constraint Ban_Trangthai_Ten check (Status in ('Available','Having a meal','Reserved'));


--Them khoa chinh
alter table Tablee
    add constraint Ban_PK PRIMARY KEY (ID_Table);


--Tao bang Voucher

--Tao bang Voucher
--drop table Voucher;

create table Voucher(
    Code_Voucher varchar2(10),
    Describee varchar2(50),
    Percentt number(3,0),
    TypeCode varchar2(50),
    Quantity number(3,0),
    Poin number(8,0)
);
--Them Check Constraint
alter table Voucher
    add constraint V_Code_NNULL check ('Code_Voucher' is not null)
    add constraint V_Mota_NNULL check ('Describee' is not null)
    add constraint V_Phantram_NNULL check (Percentt > 0 AND Percentt <= 100)
    add constraint V_LoaiMA_Thuoc check (TypeCode in ('All','Aries','Taurus','Gemini','Cancer','Leo','Virgo'
                                                 ,'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces'));

---Them khoa chinh
alter table Voucher
    add constraint Voucher_PK PRIMARY KEY (Code_Voucher);
    
--Tao bang HoaDon
--drop table HoaDon;

create table Bill(
    ID_Bill NUMBER(8,0),
    ID_Cus number(8,0),
    ID_Table number(8,0),
    DateBill date,
    Price number(8,0),
    Code_Voucher varchar2(10),
    MoneyReduced number(8,0),
    Total number(10,0),
    Status varchar2(50)
);

--Them Check Constraint
alter table Bill
    add constraint HD_NgayHD_NNULL check ('DishName' is not null)
    add constraint HD_TrangThai check (Status in ('Unpaid','Paid'));

--Them khoa chinh
alter table Bill
    add constraint HD_PK PRIMARY KEY (ID_Bill);

ALTER TABLE Bill
 ADD CONSTRAINT HD_fk_idKH FOREIGN KEY 
 (ID_Cus) REFERENCES Customer(ID_Cus)
 ADD CONSTRAINT HD_fk_idBan FOREIGN KEY 
 (ID_Table) REFERENCES Tablee(ID_Table);
 

--Tao bang CTHD
--drop table CTHD;
create table BillDetail(
    ID_Bill NUMBER(8,0),
    ID_Dish number(8,0),
    Quantity number(3,0),
    Total number(10,0)
);

--Them Check Constraint
alter table BillDetail
    add constraint CTHD_SoLuong_NNULL check ('Quantity' is not null);

--Them khoa chinh
alter table BillDetail
    add constraint CTHD_PK PRIMARY KEY (ID_Bill,ID_Dish);

ALTER TABLE BillDetail
 ADD CONSTRAINT CTHD_fk_idHD FOREIGN KEY 
 (ID_Bill) REFERENCES Bill(ID_Bill)
 ADD CONSTRAINT CTHD_fk_idMonAn FOREIGN KEY 
 (ID_Dish) REFERENCES Dish(ID_Dish);

 
--Tao bang Nguyenlieu
--drop table NguyenLieu;
create table Ingredient(
    ID_Ing NUMBER(8,0),
    IngName VARCHAR2(50), 
    Price NUMBER(8,0), 
    Unit VARCHAR2(50)
);
--Them Check Constraint
alter table Ingredient
    add constraint NL_TenNL_NNULL check ('IngName' is not null)
    add constraint NL_Dongia_NNULL check ('Price' is not null)
    add constraint NL_DVT_Thuoc check (Unit in ('g','kg','ml','l'));

--Them khoa chinh
alter table Ingredient
    add constraint NL_PK PRIMARY KEY (ID_Ing);

--Tao bang Kho
--drop table Kho;
create table WareHouse(
    ID_Ing NUMBER(8,0),
    QuantityStock NUMBER(3,0) DEFAULT 0
);
--Them Check Constraint


--Them khoa chinh
ALTER TABLE WareHouse
    ADD CONSTRAINT Kho_pk PRIMARY KEY (ID_Ing);

--Them khoa ngoai
ALTER TABLE WareHouse
 ADD CONSTRAINT Kho_fk_idNL FOREIGN KEY 
 (ID_Ing) REFERENCES Ingredient(ID_Ing);

--Tao bang PhieuNK
--drop table PhieuNK;
create table Receipt(
    ID_Re NUMBER(8,0),
    ID_Emp number(8,0),
    DateRe date,
    Total number(10,0) DEFAULT 0
);

--Them Check Constraint
alter table Receipt
    add constraint PNK_NgayNK_NNULL check ('DateRe' is not null);

--Them khoa chinh
alter table Receipt
    add constraint PNK_PK PRIMARY KEY (ID_Re);

ALTER TABLE Receipt
 ADD CONSTRAINT PNK_fk_idNV FOREIGN KEY 
 (ID_Emp) REFERENCES Employees(ID_Emp);


--Them bang CTNK
--drop table CTNK;
create table ReceiptDetail(
    ID_Re NUMBER(8,0),
    ID_Ing number(8,0),
    Quantity number(3,0),
    Total number(10,0)
);

--Them Check Constraint
alter table ReceiptDetail
    add constraint CTNK_SL_NNULL check ('Quantity' is not null);

--Them khoa chinh
alter table ReceiptDetail
    add constraint CTNK_PK PRIMARY KEY (ID_Re,ID_Ing);
    
--Them khoa ngoai
ALTER TABLE ReceiptDetail
 ADD CONSTRAINT CTNK_fk_idNK FOREIGN KEY 
 (ID_Re) REFERENCES Receipt(ID_Re)
 ADD CONSTRAINT CTNK_fk_idNL FOREIGN KEY 
 (ID_Ing) REFERENCES Ingredient(ID_Ing);


--Tao bang PhieuXK
--drop table PhieuXK;
create table Exportt(
    ID_Ex NUMBER(8,0),
    ID_Emp number(8,0),
    DateEx date
);

--Them Check Constraint
alter table Exportt
    add constraint PXK_NgayXK_NNULL check ('DateEx' is not null);

--Them khoa chinh
alter table Exportt
    add constraint PXK_PK PRIMARY KEY (ID_Ex);

ALTER TABLE Exportt
 ADD CONSTRAINT PXK_fk_idNV FOREIGN KEY 
 (ID_Emp) REFERENCES Employees(ID_Emp);


--Them bang CTXK
--drop table CTXK;
create table ExportDetail(
    ID_Ex NUMBER(8,0),
    ID_Ing number(8,0),
    Quantity number(3,0)
);

--Them Check Constraint
alter table ExportDetail
    add constraint CTXK_SL_NNULL check ('Quantity' is not null);

--Them khoa chinh
alter table ExportDetail
    add constraint CTXK_PK PRIMARY KEY (ID_Ex,ID_Ing);

--Them khoa ngoai
ALTER TABLE ExportDetail
 ADD CONSTRAINT CTNK_fk_idXK FOREIGN KEY 
 (ID_Ex) REFERENCES Exportt(ID_Ex)
 ADD CONSTRAINT CTXK_fk_idNL FOREIGN KEY 
 (ID_Ing) REFERENCES Ingredient(ID_Ing);


--- Tao Trigger

--Khach hang chi duoc co toi da mot hoa don co trang thai Chua thanh toan
CREATE OR REPLACE TRIGGER Tg_SLHD_CTT
BEFORE INSERT OR UPDATE OF ID_Cus,Status ON Bill
FOR EACH ROW
DECLARE 
    v_count NUMBER;
BEGIN
    IF :new.Status = 'Unpaid' THEN
    SELECT COUNT(*)
    INTO v_count
    FROM Bill
    WHERE ID_Cus=:new.ID_Cus AND Status='Unpaid';
    
    IF v_count>1 THEN
     RAISE_APPLICATION_ERROR(-20000,'Each customer can only have a maximum of one invoice with unpaid status');
    END IF;
    END IF;
END;
/
--  Trigger Thanh tien o CTHD bang SoLuong x Dongia cua mon an do

CREATE OR REPLACE TRIGGER Tg_CTHD_Thanhtien
BEFORE INSERT OR UPDATE OF Quantity ON BillDetail
FOR EACH ROW
DECLARE 
    gia Dish.Price%TYPE;
BEGIN
    SELECT Price
    INTO gia
    FROM Dish
    WHERE Dish.ID_Dish = :new.ID_Dish;
    
    :new.Total := :new.Quantity * gia;
END;
/ 

--- Trigger Tien mon an o Hoa Don bang tong thanh tien o CTHD
CREATE OR REPLACE TRIGGER Tg_HD_TienMonAn
AFTER INSERT OR UPDATE OR DELETE ON BillDetail
FOR EACH ROW
BEGIN
    IF INSERTING THEN    
        UPDATE Bill SET Price = Price + :new.Total WHERE Bill.ID_Bill=:new.ID_Bill;
    END IF;
    
    IF UPDATING THEN    
        UPDATE Bill SET Price = Price + :new.Total - :old.Total WHERE Bill.ID_Bill=:new.ID_Bill;
    END IF;
    
    IF DELETING THEN    
        UPDATE Bill SET Price = Price - :old.Total WHERE Bill.ID_Bill=:old.ID_Bill;
    END IF;
END;
/

--Trigger Tien giam o Hoa Don = tong thanh tien cua mon An duoc giam  x Phantram
CREATE OR REPLACE TRIGGER Tg_HD_TienGiam
AFTER INSERT OR UPDATE OR DELETE ON BillDetail
FOR EACH ROW
DECLARE 
    v_code Bill.Code_Voucher%TYPE;
    v_loaiMA Voucher.TypeCode%TYPE;
    MA_Loai Dish.TypeD%TYPE;
BEGIN
    v_code:=NULL;
--Tim Code Voucher, Loai mon an duoc Ap dung Voucher tu bang Voucher
    IF (INSERTING OR UPDATING) THEN
        SELECT Bill.Code_Voucher,Voucher.TypeCode 
        INTO v_code,v_LoaiMA
        FROM Bill
        LEFT JOIN Voucher ON Voucher.Code_Voucher = Bill.Code_Voucher
        WHERE ID_Bill=:new.ID_Bill;
    --Tim loai mon an cua Mon an vua duoc them vao CTHD   
        SELECT TypeD
        INTO MA_Loai
        FROM Dish 
        WHERE ID_Dish = :new.ID_Dish;
    END IF;
    
    IF (DELETING) THEN
        SELECT Bill.Code_Voucher,Voucher.TypeCode 
        INTO v_code,v_LoaiMA
        FROM Bill
        LEFT JOIN Voucher ON Voucher.Code_Voucher = Bill.Code_Voucher
        WHERE ID_Bill=:old.ID_Bill;
    --Tim loai mon an cua Mon an vua duoc xoa khoi CTHD   
        SELECT TypeD
        INTO MA_Loai
        FROM Dish 
        WHERE ID_Dish = :old.ID_Dish;
    END IF;
    
    IF(v_code IS NOT NULL) THEN
        IF(v_LoaiMA='All' OR v_LoaiMA=MA_Loai) THEN 
            IF INSERTING THEN    
                UPDATE Bill SET MoneyReduced = MoneyReduced + CTHD_Tinhtiengiam(:new.Total,v_code) WHERE Bill.ID_Bill=:new.ID_Bill;
            END IF;
            
            IF UPDATING THEN    
                UPDATE Bill SET MoneyReduced = MoneyReduced + CTHD_Tinhtiengiam(:new.Total,v_code) - CTHD_Tinhtiengiam(:old.Total,v_code) WHERE Bill.ID_Bill=:new.ID_Bill;
            END IF;
            
            IF DELETING THEN    
                UPDATE Bill SET MoneyReduced = MoneyReduced - CTHD_Tinhtiengiam(:old.Total,v_code) WHERE Bill.ID_Bill=:old.ID_Bill;
            END IF;
        END IF;
    END IF;
END;
/
-- Tong tien o Hoa Don = Tien mon an - Tien giam
CREATE OR REPLACE TRIGGER Tg_HD_Tongtien
AFTER INSERT OR UPDATE OF Price,MoneyReduced ON Bill
BEGIN
    UPDATE Bill SET Total= Price - MoneyReduced;
END;
/
-- Khi cap nhat Code_Voucher o HoaDon, Tinh tien giam theo thong tin cua Voucher do va giam Diem tich luy cua KH
CREATE OR REPLACE TRIGGER Tg_HD_DoiVoucher
BEFORE UPDATE OF Code_Voucher ON Bill
FOR EACH ROW
DECLARE 
    TheTotalAmounfOfTheFoodTypeReduced number(8,0);
    v_Diemdoi number;
    v_Phantram number;
    v_LoaiMA Voucher.TypeCode%TYPE;
BEGIN
    IF(:new.Code_Voucher is not null) THEN
        SELECT Poin,Percentt,TypeCode
        INTO v_Diemdoi,v_Phantram,v_LoaiMA
        FROM Voucher
        WHERE Code_Voucher=:new.Code_Voucher;
        
        KH_TruDTL(:new.ID_Cus,v_diemdoi);
        Voucher_GiamSL(:new.Code_Voucher);
        
        IF(v_LoaiMA='All') THEN
            TheTotalAmounfOfTheFoodTypeReduced := :new.Price;
        ELSE 
            SELECT SUM(Total)
            INTO TheTotalAmounfOfTheFoodTypeReduced
            FROM BillDetail 
            JOIN Dish ON Dish.ID_Dish = BillDetail.ID_Dish
            WHERE ID_Bill = :new.ID_Bill AND TypeD = v_LoaiMA;
        END IF;
        
        :new.MoneyReduced := ROUND(TheTotalAmounfOfTheFoodTypeReduced*v_Phantram/100);
        :new.Total := :new.Price-:new.MoneyReduced;
    ELSE
        RAISE_APPLICATION_ERROR(-20000,'Voucher does not exist');
    END IF;
END;
/

--Trigger Doanh so cua Khach hang bang tong tien cua tat ca hoa don co trang thai 'Da thanh toan' 
--cua khach hang do
-- Diem tich luy cua Khach hang duoc tinh bang 0.005% Tong tien cua hoa don (1.000.000d tuong duong 50 diem)
CREATE OR REPLACE TRIGGER Tg_KH_DoanhsovaDTL
AFTER UPDATE OF Status ON Bill
FOR EACH ROW
BEGIN
    IF :new.Status='Paid' THEN
        UPDATE Customer SET Sales = Sales + :new.Total WHERE ID_Cus=:new.ID_Cus;
        UPDATE Customer SET AccumulatedPoin = AccumulatedPoin + ROUND(:new.Total*0.00005)
        WHERE ID_Cus=:new.ID_Cus;
    END IF;
END;
/
--Trigger khi khach hang them hoa don moi, trang thai ban chuyen tu 'Con trong' sang 'Dang dung bua'
-- Khi trang thai don hang tro thanh 'Da thanh toan' trang thai ban chuyen tu 'Dang dung bua' sang 'Con trong'

CREATE OR REPLACE TRIGGER Tg_TrangthaiBan
AFTER INSERT OR UPDATE OF Status ON Bill
FOR EACH ROW
BEGIN
    IF(:new.Status='Unpaid') THEN 
        UPDATE Tablee SET Status='Having a meal' WHERE ID_Table=:new.ID_Table;
    ELSE 
        UPDATE Tablee SET Status='Available' WHERE ID_Table=:new.ID_Table;
    END IF; 
END;
/
--  Trigger Thanh tien o CTNK bang SoLuong x Dongia cua nguyen lieu do

CREATE OR REPLACE TRIGGER Tg_CTNK_Thanhtien
BEFORE INSERT OR UPDATE OF Quantity ON ReceiptDetail
FOR EACH ROW
DECLARE 
    gia Ingredient.Price%TYPE;
BEGIN
    SELECT Price
    INTO gia
    FROM Ingredient
    WHERE Ingredient.ID_Ing = :new.ID_Ing;
    
    :new.Total := :new.Quantity * gia;
    
END;
/
--Trigger Tong tien o PhieuNK bang tong thanh tien cua CTNK
CREATE OR REPLACE TRIGGER Tg_PNK_Tongtien
AFTER INSERT OR UPDATE OR DELETE ON ReceiptDetail
FOR EACH ROW
BEGIN
    IF INSERTING THEN    
        UPDATE Receipt SET Total = Total + :new.Total WHERE Receipt.ID_Re = :new.ID_Re;
    END IF;
    
    IF UPDATING THEN    
        UPDATE Receipt SET Total = Total + :new.Total - :old.Total WHERE Receipt.ID_Re = :new.ID_Re;
    END IF;
    
    IF DELETING THEN    
        UPDATE Receipt SET Total = Total - :old.Total WHERE Receipt.ID_Re = :old.ID_Re;
    END IF;
END;
/ 
--Trigger khi them CTNK tang So luong ton cua nguyen lieu trong kho
CREATE OR REPLACE TRIGGER Tg_Kho_ThemSLTon
AFTER INSERT OR DELETE OR UPDATE OF Quantity ON ReceiptDetail
FOR EACH ROW
BEGIN
    IF INSERTING THEN    
        UPDATE WareHouse SET QuantityStock = QuantityStock + :new.Quantity WHERE WareHouse.ID_Ing = :new.ID_Ing;
    END IF;
    
    IF UPDATING THEN    
        UPDATE WareHouse SET QuantityStock = QuantityStock + :new.Quantity - :old.Quantity WHERE WareHouse.ID_Ing = :new.ID_Ing;
    END IF;
    
    IF DELETING THEN    
        UPDATE WareHouse SET QuantityStock = QuantityStock - :old.Quantity WHERE WareHouse.ID_Ing = :old.ID_Ing;
    END IF;
END;
/
--Trigger khi them CTXK giam So luong ton cua nguyen lieu trong kho
CREATE OR REPLACE TRIGGER Tg_Kho_GiamSLTon
AFTER INSERT OR DELETE OR UPDATE OF Quantity ON ExportDetail
FOR EACH ROW
BEGIN
    IF INSERTING THEN    
        UPDATE WareHouse SET QuantityStock = QuantityStock - :new.Quantity WHERE WareHouse.ID_Ing = :new.ID_Ing;
    END IF;
    
    IF UPDATING THEN    
        UPDATE WareHouse SET QuantityStock = QuantityStock - :new.Quantity + :old.Quantity WHERE WareHouse.ID_Ing = :new.ID_Ing;
    END IF;
    
    IF DELETING THEN    
        UPDATE WareHouse SET QuantityStock = QuantityStock + :old.Quantity WHERE WareHouse.ID_Ing = :old.ID_Ing;
    END IF;
END;
/
--Trigger khi them mot Nguyen Lieu moi, them NL do vao Kho
CREATE OR REPLACE TRIGGER Tg_Kho_ThemNL
AFTER INSERT ON Ingredient
FOR EACH ROW
BEGIN
    INSERT INTO WareHouse(ID_Ing) VALUES(:new.ID_Ing);
END;
/

--Procedure
--Procudure them mot khach hang moi voi cac thong tin tenKH , NgayTG va ID_ND
CREATE OR REPLACE PROCEDURE KH_ThemKH(NameCus Customer.NameCus%TYPE, DateJ Customer.DateJ%TYPE,
ID_User Customer.ID_User%TYPE)
IS
    v_ID_Cus Customer.ID_Cus%TYPE;

BEGIN
    --Them ma KH tiep theo
    SELECT MIN(ID_Cus)+1
    INTO v_ID_Cus   
    FROM Customer
    WHERE ID_Cus + 1 NOT IN(SELECT ID_Cus FROM Customer);
    
    INSERT INTO Customer(ID_Cus,NameCus,DateJ,ID_User) VALUES (v_ID_Cus,NameCus,TO_DATE(DateJ,'dd-MM-YYYY'),ID_User);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001,'The information is not valid'|| SQLERRM, TRUE);
END;
/
--Procudure them mot nhan vien moi voi cac thong tin tenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang
CREATE OR REPLACE PROCEDURE NV_ThemNV(NameEmp Employees.NameEmp%TYPE, DateW Employees.DateW%TYPE, PhoneNum Employees.PhoneNum%TYPE,
Position Employees.Position%TYPE,ID_Manager Employees.ID_Manager%TYPE, Status Employees.Status%TYPE)
IS
    v_ID_Emp Employees.ID_Emp%TYPE;

BEGIN
    --Them ma KH tiep theo
    SELECT MIN(ID_Emp)+1
    INTO v_ID_Emp
    FROM Employees
    WHERE ID_Emp + 1 NOT IN(SELECT ID_Emp FROM Employees);
    
    INSERT INTO Employees(ID_Emp,NameEmp,DateW,PhoneNum,Position,ID_Manager,Status) 
    VALUES (v_ID_Emp,NameEmp,TO_DATE(DateW,'dd-MM-YYYY'),PhoneNum,Position,ID_Manager,Status);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001,'The information is not valid' || SQLERRM, TRUE);
END;
/
-- Procudure xoa mot NHANVIEN voi idNV
CREATE OR REPLACE PROCEDURE NV_XoaNV(ID_Emp Employees.ID_Emp%TYPE)
IS
    v_count NUMBER;
    ID_Manager Employees.ID_Manager%TYPE;
BEGIN 
    SELECT COUNT(ID_Emp),ID_Manager
    INTO v_count,ID_Manager
    FROM Employees
    WHERE ID_Emp=ID_Emp;
    
    IF(v_count>0) THEN
        IF (ID_Emp = ID_Manager) THEN
            RAISE_APPLICATION_ERROR(-20000,'Cannot delete MANAGER' || SQLERRM, TRUE);
        ELSE
            FOR cur IN (SELECT ID_Re FROM Receipt
            WHERE ID_Emp=ID_Emp
            )
            LOOP
                DELETE FROM ReceiptDetail WHERE ID_Re=cur.ID_Re;
            END LOOP;
            
            FOR cur IN (SELECT ID_Ex FROM Exportt
            WHERE ID_Emp=ID_Emp
            )
            LOOP
                DELETE FROM ExportDetail WHERE ID_Ex=cur.ID_Ex;
            END LOOP;
            
            DELETE FROM Receipt WHERE ID_Emp=ID_Emp;
            DELETE FROM Receipt WHERE ID_Emp=ID_Emp;
            DELETE FROM Employees WHERE ID_Emp=ID_Emp;
        END IF;
    ELSE 
        RAISE_APPLICATION_ERROR(-20000,'Employee does not exist' || SQLERRM, TRUE);
    END IF;
END;
/
-- Procudure xoa mot KHACHHANG voi idKH
CREATE OR REPLACE PROCEDURE KH_DeleteKH(ID_Cus Customer.ID_Cus%TYPE)
IS
    v_count NUMBER;
BEGIN 
    SELECT COUNT(*)
    INTO v_count
    FROM Customer
    WHERE ID_Cus=ID_Cus;
    
    IF(v_count>0) THEN
        FOR cur IN (SELECT ID_Bill FROM Bill 
        WHERE ID_Cus=ID_Cus
        )
        LOOP
            DELETE FROM BillDetail WHERE ID_Bill=cur.ID_Bill;
        END LOOP;
        DELETE FROM Bill WHERE ID_Cus=ID_Cus;
        DELETE FROM Customer WHERE ID_Cus=ID_Cus;
    ELSE 
        RAISE_APPLICATION_ERROR(-20000,'Customer does not exist');
    END IF;
END;
/

-- Procedure xem thong tin KHACHHANG voi thong tin idKH
CREATE OR REPLACE PROCEDURE KH_XemTT(ID_Cus Customer.ID_Cus%TYPE)
IS
BEGIN 
    FOR cur IN (SELECT NameCus,DateJ,Sales,AccumulatedPoin,ID_User
    FROM Customer WHERE ID_Cus=ID_Cus;
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Customer ID: '||ID_Cus);
        DBMS_OUTPUT.PUT_LINE('Customer Name: '||cur.NameCus);
        DBMS_OUTPUT.PUT_LINE('Date Join: '||TO_CHAR(cur.DateJ,'dd-MM-YYYY');
        DBMS_OUTPUT.PUT_LINE('Sales: '||cur.Sales);
        DBMS_OUTPUT.PUT_LINE('Poin: '||cur.AccumulatedPoin);
        DBMS_OUTPUT.PUT_LINE('UserID: '||cur.ID_User);
        END LOOP;
        EXCEPTION WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20000,'Customer does not exist');
    END LOOP;
END;
/
-- Procedure xem thong tin NHANVIEN voi thong tin idNV
CREATE OR REPLACE PROCEDURE NV_XemTT(ID_Emp Employees.ID_Emp%TYPE)
IS
BEGIN 
    FOR cur IN (SELECT NameEmp,DateW,PhoneNum,Position,ID_Manager   
    FROM Employees WHERE ID_Emp=ID_Emp;                             
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: '||ID_Emp);
        DBMS_OUTPUT.PUT_LINE('Employee Name: '||cur.NameEmp);
        DBMS_OUTPUT.PUT_LINE('Date Join: '||TO_CHAR(cur.DateW,'dd-MM-YYYY');
        DBMS_OUTPUT.PUT_LINE('Position: '||cur.Position);
        DBMS_OUTPUT.PUT_LINE('Manager ID: '||cur.ID_Manager);
        END LOOP;
        EXCEPTION WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20000,'Employee does not exist');
    END LOOP;
END;
/

-- Procedure liet ke danh sach hoa don tu ngay A den ngay B
CREATE OR REPLACE PROCEDURE DS_HoaDon_tuAdenB(fromA DATE, toB DATE)
IS
BEGIN 
    FOR cur IN (SELECT ID_Bill,ID_Cus,ID_Table,DateBill,Price,MoneyReduced,Total,Status   
    FROM Bill WHERE DateBill BETWEEN fromA AND (toB +1);
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Bill ID: '||cur.ID_Bill);
        DBMS_OUTPUT.PUT_LINE('Employee ID: '||cur.ID_Cus);
        DBMS_OUTPUT.PUT_LINE('Table ID: '||cur.ID_Table);
        DBMS_OUTPUT.PUT_LINE('Bill Date: '||TO_CHAR(cur.DateBill,'dd-MM-YYYY');
        DBMS_OUTPUT.PUT_LINE('Price: '||cur.Price);
        DBMS_OUTPUT.PUT_LINE('Money reduced: '||cur.MoneyReduced);
        DBMS_OUTPUT.PUT_LINE('Total: '||cur.Total);
        DBMS_OUTPUT.PUT_LINE('Status: '||cur.Status);
        
        EXCEPTION WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20000,'There are no invoices');
    END LOOP;
END;
/
-- Procedure liet ke danh sach phieu nhap kho tu ngay A den ngay B
CREATE OR REPLACE PROCEDURE DS_PhieuNK_tuAdenB(fromA DATE, toB DATE)
IS
BEGIN 
    FOR cur IN (SELECT ID_Re,ID_Emp,DateRe,Total  
    FROM Receipt WHERE DateRe BETWEEN fromA AND (toB +1);
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Receipt ID: '||cur.ID_Re);
        DBMS_OUTPUT.PUT_LINE('Employee ID: '||cur.ID_Emp);
        DBMS_OUTPUT.PUT_LINE('Date Receipt: '||TO_CHAR(cur.DateRe,'dd-MM-YYYY');
        DBMS_OUTPUT.PUT_LINE('Total: '||cur.Total);
        
        EXCEPTION WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20000,'There are no invoices');
    END LOOP;
END;
/

-- Procedure liet ke danh sach phieu xuat kho tu ngay A den ngay B
CREATE OR REPLACE PROCEDURE DS_PhieuXK_tuAdenB(fromA DATE, toB DATE)
IS
BEGIN 
    FOR cur IN (SELECT ID_Ex,ID_Emp,DateEx
    FROM Exportt WHERE DateEx BETWEEN fromA AND (toB +1);
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Export ID: '||cur.ID_Ex);
        DBMS_OUTPUT.PUT_LINE('Employee ID: '||cur.ID_Emp);
        DBMS_OUTPUT.PUT_LINE('Date Export: '||TO_CHAR(cur.DateEx,'dd-MM-YYYY');
        
        EXCEPTION WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20000,'There are no invoices');
    END LOOP;
END;
/
-- Procedure xem chi tiet hoa don cua 1 hoa don
CREATE OR REPLACE PROCEDURE HD_XemCTHD(idHD Bill.ID_Bill%TYPE)
IS
BEGIN 
    FOR cur IN (SELECT ID_Dish,Quantity,Total
    FROM BillDetail WHERE ID_Bill=idHD;
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Dish ID: '||cur.ID_Dish);
        DBMS_OUTPUT.PUT_LINE('Quantity: '||cur.Quantity);
        DBMS_OUTPUT.PUT_LINE('Price: '||cur.Total);
        
        EXCEPTION WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20000,'No invoice details available');
    END LOOP;
END;
/
-- Procedure giam So Luong cua Voucher di 1 khi KH doi Voucher
CREATE OR REPLACE PROCEDURE Voucher_GiamSL(code Voucher.Code_Voucher%TYPE)
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Voucher
    WHERE Code_Voucher=code;
    IF(v_count>0) THEN
        UPDATE Voucher SET Quantity = Quantity - 1 WHERE Code_Voucher=code;
    ELSE 
        RAISE_APPLICATION_ERROR(-20000,'Voucher is not valid');
    END IF;
END;
/

-- Procedure giam Diem tich luy cua KH khi doi Voucher
CREATE OR REPLACE PROCEDURE KH_TruDTL(ID Customer.ID_Cus%TYPE,diemdoi NUMBER)
IS
    v_count NUMBER;
BEGIN 
    SELECT COUNT(*)
    INTO v_count
    FROM Customer
    WHERE ID_Cus=ID;
    IF(v_count>0) THEN
        UPDATE Customer SET AccumulatedPoin = AccumulatedPoin - diemdoi WHERE ID_Cus=ID;
    ELSE 
        RAISE_APPLICATION_ERROR(-20000,'Customers are not attentive');
    END IF;
END;
/

--Fuction 
--Fuction Tinh doanh thu hoa don theo ngay
CREATE OR REPLACE FUNCTION DoanhThuHD_theoNgay (DateBill DATE)
RETURN NUMBER
IS 
    v_Doanhthu NUMBER;
BEGIN
    SELECT SUM(Total)
    INTO v_Doanhthu
    FROM Bill 
    WHERE DateBill=DateBill;
    
    v_Doanhthu := NVL(v_Doanhthu,0);
    RETURN v_Doanhthu;
END;
/
--Fuction Tinh chi phi nhap kho theo ngay
CREATE OR REPLACE FUNCTION ChiPhiNK_theoNgay (DateRe DATE)
RETURN NUMBER
IS 
    v_Chiphi NUMBER;
BEGIN
    SELECT SUM(Total)
    INTO v_Chiphi
    FROM Receipt 
    WHERE DateRe=DateRe;
    
    v_Chiphi := NVL(v_Chiphi,0);
    RETURN v_Chiphi;
END;
/
--Fuction Tinh doanh so trung binh cua x KHACHHANG co doanh so cao nhat
CREATE OR REPLACE FUNCTION DoanhsoTB_TOPxKH(x INT)
RETURN DECIMAL
IS 
   v_avg DECIMAL;
BEGIN
    SELECT AVG(Sales)
    INTO v_avg
    FROM (
        SELECT Sales 
        FROM Customer
        ORDER BY Sales DESC
        FETCH FIRST x ROWS ONLY
        );
    RETURN v_avg;
END;
/

--Fuction Tinh so luong KHACHANG moi trong thang chi dinh cua nam co it nhat mot hoa don co tri gia tren x vnd
CREATE OR REPLACE FUNCTION SL_KH_Moi(thang NUMBER, nam NUMBER, trigiaHD NUMBER)
RETURN NUMBER
IS 
   v_count NUMBER;
BEGIN
    SELECT COUNT(ID_Cus)
    INTO v_count;
    FROM Customer
    WHERE EXTRACT(MONTH FROM DateJ)=thang AND EXTRACT(YEAR FROM DateJ) = nam
    AND EXISTS(SELECT *
               FROM Bill 
               WHERE Bill.ID_Cus=Customer.ID_Cus AND Total>trigiaHD
               );
    RETURN v_count;          
END;
/
    
--Fuction Tinh tien mon an duoc giam khi them mot CTHD moi
CREATE OR REPLACE FUNCTION CTHD_Tinhtiengiam(Total Number,Code Voucher.Code_Voucher%TYPE)
RETURN NUMBER
IS 
    MoneyReduced NUMBER;
    v_phantram NUMBER;
BEGIN
    SELECT Percentt
    INTO v_Phantram
    FROM Voucher
    WHERE Code_Voucher=Code;
    MoneyReduced := ROUND(Total*v_Phantram/100);
    RETURN MoneyReduced;
END;
/
--Them data
ALTER SESSION SET NLS_DATE_FORMAT = 'dd-MM-YYYY';
--Them data cho Bang NguoiDung
--Nhan vien
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (100,'NVHoangViet@gmail.com','123','Verified','Manager');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (101,'NVHoangPhuc@gmail.com','123','Verified','Employee');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (102,'NVAnhHong@gmail.com','123','Verified','Employee House');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (103,'NVQuangDinh@gmail.com','123','Verified','Employee');
--Khach Hang
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (99,'hoang@gmail.com','123','Verified','Customer');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (104,'KHThaoDuong@gmail.com','123','Verified','Customer');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (105,'KHTanHieu@gmail.com','123','Verified','Customer');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (106,'KHQuocThinh@gmail.com','123','Verified','Customer');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (107,'KHNhuMai@gmail.com','123','Verified','Customer');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (108,'KHBichHao@gmail.com','123','Verified','Customer');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (109,'KHMaiQuynh@gmail.com','123','Verified','Customer');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (110,'KHMinhQuang@gmail.com','123','Verified','Customer');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (111,'KHThanhHang@gmail.com','123','Verified','Customer');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (112,'KHThanhNhan@gmail.com','123','Verified','Customer');
INSERT INTO Userr(ID_User, Email, Password, Status, Role) VALUES (113,'KHPhucNguyen@gmail.com','123','Verified','Customer');

--Them data cho bang Nhan Vien
ALTER SESSION SET NLS_DATE_FORMAT = 'dd-MM-YYYY';
--Co tai khoan
INSERT INTO Employees(ID_Emp, NameEmp, DateW, PhoneNum, Position, ID_User, ID_Manager, Status) VALUES (100,'Nguyen Hoang Viet','10/05/2023','0848044725','Manager',100,100,'Working');
INSERT INTO Employees(ID_Emp, NameEmp, DateW, PhoneNum, Position, ID_User, ID_Manager, Status) VALUES (101,'Nguyen Hoang Phuc','20/05/2023','0838033334','Reception',101,100,'Working');
INSERT INTO Employees(ID_Emp, NameEmp, DateW, PhoneNum, Position, ID_User, ID_Manager, Status) VALUES (102,'Le Thi Anh Hong','19/05/2023','0838033234','House',102,100,'Working');
INSERT INTO Employees(ID_Emp, NameEmp, DateW, PhoneNum, Position, ID_User, ID_Manager, Status) VALUES (103,'Ho Quang Dinh','19/05/2023','0838033234','Reception',103,100,'Working');
--Khong co tai khoan


--Them data cho bang KhachHang
INSERT INTO Customer(ID_Cus, NameCus, DateJ, ID_User) VALUES (99,'Hoang','10/05/2023',99);
INSERT INTO Customer(ID_Cus, NameCus, DateJ, ID_User) VALUES (100,'Ha Thao Duong','10/05/2023',104);
INSERT INTO Customer(ID_Cus, NameCus, DateJ, ID_User) VALUES (101,'Truong Tan Hieu','10/05/2023',105);
INSERT INTO Customer(ID_Cus, NameCus, DateJ, ID_User) VALUES (102,'Nguyen Quoc Thinh','10/05/2023',106);
INSERT INTO Customer(ID_Cus, NameCus, DateJ, ID_User) VALUES (103,'Tran Nhu Mai','10/05/2023',107);
INSERT INTO Customer(ID_Cus, NameCus, DateJ, ID_User) VALUES (104,'Nguyen Thi Bich Hao','10/05/2023',108);
INSERT INTO Customer(ID_Cus, NameCus, DateJ, ID_User) VALUES (105,'Nguyen Mai Quynh','11/05/2023',109);
INSERT INTO Customer(ID_Cus, NameCus, DateJ, ID_User) VALUES (106,'Hoang Minh Quang','11/05/2023',110);
INSERT INTO Customer(ID_Cus, NameCus, DateJ, ID_User) VALUES (107,'Nguyen Thanh Hang','12/05/2023',111);
INSERT INTO Customer(ID_Cus, NameCus, DateJ, ID_User) VALUES (108,'Nguyen Ngoc Thanh Nhan','11/05/2023',112);
INSERT INTO Customer(ID_Cus, NameCus, DateJ, ID_User) VALUES (109,'Hoang Thi Phuc Nguyen','12/05/2023',113);

--Them data cho bang MonAn
--Aries
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(1,'DUI CUU NUONG XE NHO', 250000,'Aries','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(2,'BE SUON CUU NUONG GIAY BAC MONG CO', 230000,'Aries','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(3,'DUI CUU NUONG TRUNG DONG', 350000,'Aries','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(4,'CUU XOC LA CA RI', 129000,'Aries','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(5,'CUU KUNGBAO', 250000,'Aries','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(6,'BAP CUU NUONG CAY', 250000,'Aries','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(7,'CUU VIEN HAM CAY', 19000,'Aries','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(8,'SUON CONG NUONG MONG CO', 250000,'Aries','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(9,'DUI CUU LON NUONG TAI BAN', 750000,'Aries','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(10,'SUONG CUU NUONG SOT NAM', 450000,'Aries','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(11,'DUI CUU NUONG TIEU XANH', 285000,'Aries','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(12,'SUON CUU SOT PHO MAI', 450000,'Aries','are trading');

--Taurus
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(13,'Bit tet bo My khoai tay', 179000,'Taurus','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(14,'Bo bit tet Uc',169000,'Taurus','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(15,'Bit tet bo My BASIC', 179000,'Taurus','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(16,'My Y bo bam', 169000,'Taurus','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(17,'Thit suon Wagyu', 1180000,'Taurus','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(18,'Steak Thit Vai Wagyu', 1290000,'Taurus','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(19,'Steak Thit Bung Bo', 550000,'Taurus','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(20,'Tomahawk', 2390000,'Taurus','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(21,'Salad Romaine Nuong', 180000,'Taurus','are trading');

--Gemini
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(22,'Combo Happy', 180000,'Gemini','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(23,'Combo Fantastic', 190000,'Gemini','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(24,'Combo Dreamer', 230000,'Gemini','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(25,'Combo Cupid', 180000,'Gemini','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(26,'Combo Poseidon', 190000,'Gemini','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(27,'Combo LUANG PRABANG', 490000,'Gemini','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(28,'Combo VIENTIANE', 620000,'Gemini','are trading');

--Cancer
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(29,'Cua KingCrab Duc sot', 3650000,'Cancer','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(30,'Mai Cua KingCrab Topping Pho Mai', 2650000,'Cancer','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(31,'Cua KingCrab sot Tu Xuyen', 2300000,'Cancer','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(32,'Cua KingCrab Nuong Tu Nhien', 2550000,'Cancer','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(33,'Cua KingCrab Nuong Bo Toi', 2650000,'Cancer','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(34,'Com Mai Cua KingCrab Chien', 1850000,'Cancer','are trading');

--Leo
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(35,'BOSSAM', 650000,'Leo','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(36,'KIMCHI PANCAKE', 350000,'Leo','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(37,'SPICY RICE CAKE', 250000,'Leo','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(38,'SPICY SAUSAGE HOTPOT', 650000,'Leo','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(39,'SPICY PORK', 350000,'Leo','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(40,'MUSHROOM SPICY SILKY TOFU STEW', 350000,'Leo','are trading');
--Virgo
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(41,'Pavlova', 150000,'Virgo','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(42,'Kesutera', 120000,'Virgo','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(43,'Cremeschnitte', 250000,'Virgo','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(44,'Sachertorte', 150000,'Virgo','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(45,'Schwarzwalder Kirschtorte', 250000,'Virgo','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(46,'New York-Style Cheesecake', 250000,'Virgo','are trading');

--Libra
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(47,'Cobb Salad', 150000,'Libra','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(48,'Salad Israeli', 120000,'Libra','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(49,'Salad Dau den', 120000,'Libra','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(50,'Waldorf Salad', 160000,'Libra','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(51,'Salad Gado-Gado', 200000,'Libra','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(52,'Nicoise Salad', 250000,'Libra','are trading');

--Scorpio
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(53,'BULGOGI LUNCHBOX', 250000,'Scorpio','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(54,'CHICKEN TERIYAKI LUNCHBOX', 350000,'Scorpio','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(55,'SPICY PORK LUNCHBOX', 350000,'Scorpio','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(56,'TOFU TERIYAKI LUNCHBOX', 250000,'Scorpio','are trading');

--Sagittarius
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(57,'Thit ngua do tuoi', 250000,'Sagittarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(58,'Steak Thit ngua', 350000,'Sagittarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(59,'Thit ngua ban gang', 350000,'Sagittarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(60,'Long ngua xao dua', 150000,'Sagittarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(61,'Thit ngua xao sa ot', 250000,'Sagittarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(62,'Ngua tang', 350000,'Sagittarius','are trading');

--Capricorn
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(63,'Thit de xong hoi', 229000,'Capricorn','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(64,'Thit de xao rau ngo', 199000,'Capricorn','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(65,'Thit de nuong tang', 229000,'Capricorn','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(66,'Thit de chao', 199000,'Capricorn','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(67,'Thit de nuong xien', 199000,'Capricorn','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(68,'Nam de nuong/chao', 199000,'Capricorn','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(69,'Thit de xao lan', 19000,'Capricorn','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(70,'Dui de tan thuoc bac', 199000,'Capricorn','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(71,'Canh de ham duong quy', 199000,'Capricorn','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(72,'Chao de dau xanh', 50000,'Capricorn','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(73,'Thit de nhung me', 229000,'Capricorn','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(74,'Lau de nhu', 499000,'Capricorn','are trading');


--Aquarius
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(75,'SIGNATURE WINE', 3290000,'Aquarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(76,'CHILEAN WINE', 3990000,'Aquarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(77,'ARGENTINA WINE', 2890000,'Aquarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(78,'ITALIAN WINE', 5590000,'Aquarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(79,'AMERICAN WINE', 4990000,'Aquarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(80,'CLASSIC COCKTAIL', 200000,'Aquarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(81,'SIGNATURE COCKTAIL', 250000,'Aquarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(82,'MOCKTAIL', 160000,'Aquarius','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(83,'JAPANESE SAKE', 1490000,'Aquarius','are trading');

--Pisces
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(84,'Ca Hoi Ngam Tuong', 289000,'Pisces','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(85,'Ca Ngu Ngam Tuong', 289000,'Pisces','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(86,'IKURA:Trung ca hoi', 189000,'Pisces','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(87,'KARIN:Sashimi Ca Ngu', 149000,'Pisces','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(88,'KEIKO:Sashimi Ca Hoi', 199000,'Pisces','are trading');
insert into Dish(ID_Dish, DishName, Price, TypeD, Status) values(89,'CHIYO:Sashimi Bung Ca Hoi', 219000,'Pisces','are trading');

--Them data cho bang Ban
--Tang 1
insert into Tablee(ID_Table, TableName, Locationn, Status) values(100,'Ban T1.1','Floor 1','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(101,'Ban T1.2','Floor 1','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(102,'Ban T1.3','Floor 1','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(103,'Ban T1.4','Floor 1','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(104,'Ban T1.5','Floor 1','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(105,'Ban T1.6','Floor 1','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(106,'Ban T1.7','Floor 1','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(107,'Ban T1.8','Floor 1','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(108,'Ban T1.9','Floor 1','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(109,'Ban T1.10','Floor 1','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(110,'Ban T1.11','Floor 1','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(111,'Ban T1.12','Floor 1','Available');
--Tang 2
insert into Tablee(ID_Table, TableName, Locationn, Status) values(112,'Ban T2.1','Floor 2','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(113,'Ban T2.2','Floor 2','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(114,'Ban T2.3','Floor 2','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(115,'Ban T2.4','Floor 2','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(116,'Ban T2.5','Floor 2','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(117,'Ban T2.6','Floor 2','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(118,'Ban T2.7','Floor 2','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(119,'Ban T2.8','Floor 2','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(120,'Ban T2.9','Floor 2','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(121,'Ban T2.10','Floor 2','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(122,'Ban T2.11','Floor 2','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(123,'Ban T2.12','Floor 2','Available');
--Tang 3
insert into Tablee(ID_Table, TableName, Locationn, Status) values(124,'Ban T3.1','Floor 3','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(125,'Ban T3.1','Floor 3','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(126,'Ban T3.1','Floor 3','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(127,'Ban T3.1','Floor 3','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(128,'Ban T3.1','Floor 3','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(129,'Ban T3.1','Floor 3','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(130,'Ban T3.1','Floor 3','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(131,'Ban T3.1','Floor 3','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(132,'Ban T3.1','Floor 3','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status)values(133,'Ban T3.1','Floor 3','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(134,'Ban T3.1','Floor 3','Available');
insert into Tablee(ID_Table, TableName, Locationn, Status) values(135,'Ban T3.1','Floor 3','Available');

--Them data cho bang Voucher
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin) values ('loQy','20% off for Aries Menu',20,'Aries',10,200);
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin) values ('pCfI','30% off for Taurus Menu',30,'Taurus',5,300);
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin) values ('pApo','20% off for Gemini Menu',20,'Gemini',10,200);
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin) values ('ugQx','100% off for Virgo Menu',100,'Virgo',3,500);
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin) values ('nxVX','20% off for All Menu',20,'All',5,300);
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin) values ('Pwyn','20% off for Cancer Menu',20,'Cancer',10,200);
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin) values ('bjff','50% off for Leo Menu',50,'Leo',5,600);
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin) values ('YPzJ','20% off for Aquarius Menu',20,'Aquarius',5,200);
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin) values ('Y5g0','30% off for Pisces Menu',30,'Pisces',5,300);
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin)values ('7hVO','60% off for Aries Menu',60,'Aries',0,1000);
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin) values ('WHLm','20% off for Capricorn Menu',20,'Capricorn',0,200);
insert into Voucher(Code_voucher, Describee, Percentt, TypeCode, Quantity, Poin) values ('GTsC','20% off for Leo Menu',20,'Leo',0,200);


--Them data cho bang HoaDon
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (101,100,100,'10-1-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (102,104,102,'15-1-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (103,105,103,'20-1-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (104,101,101,'13-2-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (105,103,120,'12-2-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (106,104,100,'16-3-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (107,107,103,'20-3-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (108,108,101,'10-4-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (109,100,100,'20-4-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (110,103,101,'5-5-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (111,106,102,'10-5-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (112,108,103,'15-5-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (113,106,102,'20-5-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (114,108,103,'5-6-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (115,109,104,'7-6-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (116,100,105,'7-6-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (117,106,106,'10-6-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (118,102,106,'10-2-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (119,103,106,'12-2-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (120,104,106,'10-4-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (121,105,106,'12-4-2023',0,0,'Unpaid');
INSERT INTO Bill(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Status) VALUES (122,107,106,'12-5-2023',0,0,'Unpaid');

--Them data cho CTHD
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (101,1,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (101,3,1);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (101,10,3);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (102,1,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (102,2,1);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (102,4,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (103,12,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (104,30,3);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (104,59,4);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (105,28,1);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (105,88,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (106,70,3);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (106,75,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (106,78,4);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (107,32,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (107,12,5);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (108,12,1);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (108,40,4);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (109,45,4);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (110,34,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (111,65,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (111,47,4);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (112,49,3);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (112,80,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (112,31,5);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (113,80,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (113,80,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (114,30,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (114,32,3);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (115,80,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (116,57,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (116,34,1);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (117,67,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (117,66,3);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (118,34,10);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (118,35,5);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (119,83,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (119,78,2);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (120,38,5);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (120,39,4);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (121,53,5);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (121,31,4);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (122,33,5);
INSERT INTO BillDetail(ID_Bill, ID_Dish, Quantity) VALUES (122,34,6);
UPDATE Bill SET Status='Paid';

--Them data cho bang NguyenLieu
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(100,'Thit ga',40000,'kg');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(101,'Thit heo',50000,'kg');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(102,'Thit bo',80000,'kg');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(103,'Tom',100000,'kg');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(104,'Ca hoi',500000,'kg');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(105,'Gao',40000,'kg');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(106,'Sua tuoi',40000,'l');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(107,'Bot mi',20000,'kg');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(108,'Dau ca hoi',1000000,'l');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(109,'Dau dau nanh',150000,'l');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(110,'Muoi',20000,'kg');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(111,'Duong',20000,'kg');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(112,'Hanh tay',50000,'kg');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(113,'Toi',30000,'kg');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(114,'Dam',50000,'l');
INSERT INTO Ingredient(ID_Ing, IngName, Price, Unit) VALUES(115,'Thit de',130000,'kg');

--Them data cho PhieuNK
INSERT INTO Receipt(ID_Re, ID_Emp, DateRe) VALUES (100,102,'10-01-2023');
INSERT INTO Receipt(ID_Re, ID_Emp, DateRe) VALUES (101,102,'11-02-2023');
INSERT INTO Receipt(ID_Re, ID_Emp, DateRe) VALUES (102,102,'12-02-2023');
INSERT INTO Receipt(ID_Re, ID_Emp, DateRe) VALUES (103,102,'12-03-2023');
INSERT INTO Receipt(ID_Re, ID_Emp, DateRe) VALUES (104,102,'15-03-2023');
INSERT INTO Receipt(ID_Re, ID_Emp, DateRe) VALUES (105,102,'12-04-2023');
INSERT INTO Receipt(ID_Re, ID_Emp, DateRe) VALUES (106,102,'15-04-2023');
INSERT INTO Receipt(ID_Re, ID_Emp, DateRe) VALUES (107,102,'12-05-2023');
INSERT INTO Receipt(ID_Re, ID_Emp, DateRe) VALUES (108,102,'15-05-2023');
INSERT INTO Receipt(ID_Re, ID_Emp, DateRe) VALUES (109,102,'5-06-2023');
INSERT INTO Receipt(ID_Re, ID_Emp, DateRe) VALUES (110,102,'7-06-2023');

--Them data cho CTNK
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (100,100,10);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (100,101,20);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (100,102,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (101,101,10);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (101,103,20);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (101,104,10);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (101,105,10);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (101,106,20);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (101,107,5);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (101,108,5);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (102,109,10);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (102,110,20);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (102,112,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (102,113,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (102,114,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (103,112,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (103,113,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (103,114,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (104,112,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (104,113,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (105,110,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (106,102,25);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (106,115,25);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (107,110,35);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (107,105,25);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (108,104,25);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (108,103,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (108,106,30);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (109,112,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (109,113,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (109,114,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (110,102,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (110,106,25);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (110,107,15);
INSERT INTO ReceiptDetail(ID_Re, ID_Ing, Quantity) VALUES (110,110,20);

--Them data cho PhieuXK
INSERT INTO Exportt(ID_Ex, ID_Emp, DateEx) VALUES (100,102,'10-01-2023');
INSERT INTO Exportt(ID_Ex, ID_Emp, DateEx) VALUES (101,102,'11-02-2023');
INSERT INTO Exportt(ID_Ex, ID_Emp, DateEx) VALUES (102,102,'12-03-2023');
INSERT INTO Exportt(ID_Ex, ID_Emp, DateEx) VALUES (103,102,'13-03-2023');
INSERT INTO Exportt(ID_Ex, ID_Emp, DateEx) VALUES (104,102,'12-04-2023');
INSERT INTO Exportt(ID_Ex, ID_Emp, DateEx) VALUES (105,102,'13-04-2023');
INSERT INTO Exportt(ID_Ex, ID_Emp, DateEx) VALUES (106,102,'12-05-2023');
INSERT INTO Exportt(ID_Ex, ID_Emp, DateEx) VALUES (107,102,'15-05-2023');
INSERT INTO Exportt(ID_Ex, ID_Emp, DateEx) VALUES (108,102,'20-05-2023');
INSERT INTO Exportt(ID_Ex, ID_Emp, DateEx) VALUES (109,102,'5-06-2023');
INSERT INTO Exportt(ID_Ex, ID_Emp, DateEx) VALUES (110,102,'10-06-2023');

--Them data cho CTXK
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (100,100,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (100,101,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (100,102,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (101,101,7);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (101,103,10);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (101,104,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (101,105,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (101,106,10);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (102,109,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (102,110,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (102,112,10);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (102,113,8);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity)VALUES (102,114,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (103,114,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (103,104,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (104,101,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (104,112,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (105,113,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (105,102,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (106,103,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (106,114,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (107,105,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (107,106,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (108,115,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (108,110,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (109,110,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (109,112,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (110,113,5);
INSERT INTO ExportDetail(ID_Ex, ID_Ing, Quantity) VALUES (110,114,5);