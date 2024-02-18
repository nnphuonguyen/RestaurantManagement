package RTDRestaurant.Controller.Service;

import RTDRestaurant.Controller.Connection.DatabaseConnection;
import RTDRestaurant.Model.ModelBan;
import RTDRestaurant.Model.ModelCTNK;
import RTDRestaurant.Model.ModelCTXK;
import RTDRestaurant.Model.ModelHoaDon;
import RTDRestaurant.Model.ModelKhachHang;
import RTDRestaurant.Model.ModelKho;
import RTDRestaurant.Model.ModelNguyenLieu;
import RTDRestaurant.Model.ModelNhanVien;
import RTDRestaurant.Model.ModelPNK;
import RTDRestaurant.Model.ModelPXK;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

public class ServiceStaff {

    private final Connection con;

    //Connect tới DataBase       
    public ServiceStaff() {
        con = DatabaseConnection.getInstance().getConnection();
    }

    //Lấy thông tin nhân viên từ ID người dùng
    public ModelNhanVien getStaff(int userID) throws SQLException {
        ModelNhanVien data = null;
        String sql = "SELECT ID_Emp, NameEmp, to_char(DateW, 'dd-mm-yyyy') AS Day, PhoneNum, Position, ID_Manager FROM Employees WHERE ID_User=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, userID);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Emp = r.getInt("ID_Emp");
            String NameEmp = r.getString("NameEmp");
            String DateW = r.getString("Day");
            String PhoneNum = r.getString("PhoneNum");
            String Position = r.getString("Position");
            int ID_Manager = r.getInt("ID_Manager");
            data = new ModelNhanVien(ID_Emp, NameEmp, DateW, PhoneNum, Position, ID_Manager);
        }
        r.close();
        p.close();
        return data;
    }
    // Đổi tên Khách hàng 
    public void reNameStaff(ModelNhanVien data) throws SQLException {
        String sql = "UPDATE Employees SET NameEmp=? WHERE ID_Emp=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, data.getTenNV());
        p.setInt(2, data.getId_NV());
        p.execute();
        p.close();
    }
    //Lấy toàn bộ danh sách nguyên liệu
    public ArrayList<ModelNguyenLieu> MenuNL() throws SQLException {
        ArrayList<ModelNguyenLieu> list = new ArrayList<>();
        String sql = "SELECT ID_Ing,IngName,Price,Unit FROM Ingredient ORDER BY ID_Ing";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int id = r.getInt(1);  //Mã nguyên liệu
            String IngName = r.getString(2); //Tên nguyên liệu
            int Price = r.getInt(3); //Đơn giá nhập nguyên liệu
            String Unit = r.getString(4); //Đơn vị tính của nguyên liệu
            ModelNguyenLieu data = new ModelNguyenLieu(id, IngName, Price, Unit);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy thông tin của nguyên liệu theo ID
    public ModelNguyenLieu getNLbyID(int idNL) throws SQLException {
        ModelNguyenLieu data = null;
        String sql = "SELECT ID_Ing,IngName,Price,Unit FROM Ingredient WHERE ID_Ing=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, idNL);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int id = r.getInt(1);  //Mã nguyên liệu
            String IngName = r.getString(2); //Tên nguyên liệu
            int Price = r.getInt(3); //Đơn giá nhập nguyên liệu
            String Unit = r.getString(4); //Đơn vị tính của nguyên liệu
            data = new ModelNguyenLieu(id, IngName, Price, Unit);
        }
        r.close();
        p.close();
        return data;
    }

    //Lấy ID của Nguyên Liệu tiếp theo được thêm
    public int getNextID_NL() throws SQLException {
        int nextID = 0;
        String sql = "SELECT MAX(ID_Ing) as ID FROM Ingredient";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            nextID = r.getInt("ID") + 1;
        }
        r.close();
        p.close();
        return nextID;
    }

    //Thêm một nguyên liệu mới
    public void InsertNL(ModelNguyenLieu data) throws SQLException {
        String sql = "INSERT INTO Ingredient(ID_Ing,IngName,Price,Unit) VALUES(?,?,?,?)";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, data.getId());
        p.setString(2, data.getTenNL());
        p.setInt(3, data.getDonGia());
        p.setString(4, data.getDvt());
        p.execute();
        p.close();
    }

    //Xóa một nguyên liệu
    public void DeleteNL(ModelNguyenLieu data) throws SQLException {
        //Xóa nguyên liệu đó khỏi KHO
        String sql = "DELETE FROM WareHouse WHERE ID_Ing = ?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, data.getId());
        p.execute();
        //Xóa nguyên liệu đó khỏi bảng NGUYENLIEU
        sql = "DELETE FROM Ingredient WHERE ID_Ing = ?";
        p = con.prepareStatement(sql);
        p.setInt(1, data.getId());
        p.execute();
        p.close();
    }

    //Sửa một nguyên liệu
    public void UpdateNL(ModelNguyenLieu data) throws SQLException {
        String sql = "UPDATE Ingredient SET IngName = ?, Price = ?, Unit = ? WHERE ID_Ing = ?";
        PreparedStatement p = con.prepareStatement(sql);
         p.setString(1, data.getTenNL());
        p.setInt(2, data.getDonGia());
        p.setString(3, data.getDvt());
        p.setInt(4, data.getId());
        p.execute();
        p.close();
    }

    //Lấy toàn bộ danh sách Phiếu nhập kho
    public ArrayList<ModelPNK> MenuPNK() throws SQLException {
        ArrayList<ModelPNK> list = new ArrayList<>();
        String sql = "SELECT ID_Re,ID_Emp,to_char(DateRe,'dd-mm-yyyy') AS Day,Total FROM Receipt ORDER BY ID_Re";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Re = r.getInt(1);
            int ID_Emp = r.getInt(2);
            String DateRe = r.getString(3);
            int Total = r.getInt(4);
            ModelPNK data = new ModelPNK(ID_Re, ID_Emp, DateRe, Total);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy thông tin của Phiếu nhập kho theo ID
    public ModelPNK getPNKbyID(int id) throws SQLException {
        ModelPNK data = null;
        String sql = "SELECT ID_Re,ID_Emp,to_char(DateRe,'dd-mm-yyyy') AS Day,Total FROM Receipt WHERE ID_Re=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, id);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Re = r.getInt(1);
            int ID_Emp = r.getInt(2);
            String DateRe = r.getString(3);
            int Total = r.getInt(4);
            data = new ModelPNK(ID_Re, ID_Emp, DateRe, Total);
        }
        r.close();
        p.close();
        return data;
    }

    //Lấy tổng tiền nhập trong ngày hiện tại
    public int getTongtienNK() throws SQLException {
        int Total = 0;
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-YYYY");
        String sql = "SELECT SUM(Total) FROM Receipt WHERE DateRe=to_date(?, 'dd-mm-yyyy')";
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, simpleDateFormat.format(new Date()));
        ResultSet r = p.executeQuery();
        while (r.next()) {
            Total = r.getInt(1);
        }
        r.close();
        p.close();
        return Total;
    }

    //Lấy danh sách chi tiết nhập kho theo mã nhập kho
    public ArrayList<ModelCTNK> getCTNK(int idnk) throws SQLException {
        ArrayList<ModelCTNK> list = new ArrayList<>();
        String sql = "SELECT ID_Re,ReceiptDetail.ID_Ing, IngName,Unit,Quantity,Total FROM ReceiptDetail "
                + "JOIN Ingredient ON Ingredient.ID_Ing=ReceiptDetail.ID_Ing WHERE ID_Re=? ORDER BY ID_Re";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, idnk);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Re = r.getInt(1);
            int ID_Ing = r.getInt(2);
            String IngName = r.getString(3);
            String Unit = r.getString(4);
            int Quantity = r.getInt(5);
            int Total = r.getInt(6);
            ModelCTNK data = new ModelCTNK(ID_Re, ID_Ing, IngName, Unit, Quantity, Total);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy toàn bộ danh sách Phiếu xuất kho
    public ArrayList<ModelPXK> MenuPXK() throws SQLException {
        ArrayList<ModelPXK> list = new ArrayList<>();
        String sql = "SELECT ID_Ex,ID_Emp,to_char(DateEx,'dd-mm-yyyy') AS Day FROM Exportt ORDER BY ID_Ex";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Ex = r.getInt(1);
            int ID_Emp = r.getInt(2);
            String DateEx = r.getString(3);
            ModelPXK data = new ModelPXK(ID_Ex, ID_Emp, DateEx);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy thông tin của Phiếu xuất kho theo ID
    public ModelPXK getPXKbyID(int id) throws SQLException {
        ModelPXK data = null;
        String sql = "SELECT ID_Ex,ID_Emp,to_char(DateEx,'dd-mm-yyyy') AS Day FROM Exportt WHERE ID_Ex=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, id);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Ex = r.getInt(1);
            int ID_Emp = r.getInt(2);
            String DateEx = r.getString(3);
            data = new ModelPXK(ID_Ex, ID_Emp, DateEx);
        }
        r.close();
        p.close();
        return data;
    }

    //Lấy số lượng phiếu xuất kho trong ngày hiện tại
    public int getSLPXK() throws SQLException {
        int sl = 0;
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-YYYY");
        String sql = "SELECT COUNT(*) FROM Exportt WHERE DateEx=to_date(?, 'dd-mm-yyyy')";
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, simpleDateFormat.format(new Date()));
        ResultSet r = p.executeQuery();
        while (r.next()) {
            sl = r.getInt(1);
        }
        r.close();
        p.close();
        return sl;
    }

    //Lấy danh sách chi tiết Xuất kho theo ID_XK
    public ArrayList<ModelCTXK> getCTXK(int idxk) throws SQLException {
        ArrayList<ModelCTXK> list = new ArrayList<>();
        String sql = "SELECT ID_Ex,ExportDetail.ID_Ing, IngName,Unit,Quantity FROM ExportDetail "
                + "JOIN Ingredient ON Ingredient.ID_Ing=ExportDetail.ID_Ing WHERE ID_Ex=? ORDER BY ID_Ex";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, idxk);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Re = r.getInt(1);
            int ID_Ing = r.getInt(2);
            String IngName = r.getString(3);
            String Unit = r.getString(4);
            int Quantity = r.getInt(5);
            ModelCTXK data = new ModelCTXK(ID_Re, ID_Ing, IngName, Unit, Quantity);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy toàn bộ danh sách nguyên liệu trong kho
    public ArrayList<ModelKho> MenuKhoNL() throws SQLException {
        ArrayList<ModelKho> list = new ArrayList<>();
        String sql = "SELECT WareHouse.ID_Ing,IngName,Unit,QuantityStock FROM WareHouse "
                + "JOIN Ingredient ON Ingredient.ID_Ing=WareHouse.ID_Ing ORDER BY WareHouse.ID_Ing";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Ing = r.getInt(1);  //Mã nguyên liệu
            String IngName = r.getString(2); //Tên nguyên liệu
            String Unit = r.getString(3); //Đơn vị tính của nguyên liệu
            int QuantityStock = r.getInt(4);
            ModelKho data = new ModelKho(ID_Ing, IngName, Unit, QuantityStock);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy số lượng nguyên liệu còn trong kho  (Số lượng tồn >0)
    public int getSLNL_TonKho() throws SQLException {
        int sl = 0;
        String sql = "SELECT COUNT(*) FROM WareHouse WHERE QuantityStock>0";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            sl = r.getInt(1);
        }
        return sl;
    }

    //Lấy ID của Phiếu nhập kho tiếp theo được thêm
    public int getNextID_NK() throws SQLException {
        int nextID = 0;
        String sql = "SELECT MAX(ID_Ex) as ID FROM Exportt";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            nextID = r.getInt("ID") + 1;
        }
        r.close();
        p.close();
        return nextID;
    }

    //Lấy ID của Phiếu xuất kho tiếp theo được thêm
    public int getNextID_XK() throws SQLException {
        int nextID = 0;
        String sql = "SELECT MAX(ID_Ex) as ID FROM Exportt";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            nextID = r.getInt("ID") + 1;
        }
        r.close();
        p.close();
        return nextID;
    }

    //Thêm phiếu nhập kho và chi tiết Nhập kho
    public void InsertPNK_CTNK(ModelPNK pnk, ArrayList<ModelKho> list) throws SQLException {
        //Thêm phiếu nhập kho
        String sql = "INSERT INTO Receipt(ID_Re,ID_Emp,DateRe) VALUES (?,?,to_date(?, 'dd-mm-yyyy'))";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, pnk.getIdNK());
        p.setInt(2, pnk.getIdNV());
        p.setString(3, pnk.getNgayNK());
        p.execute();
        //Thêm chi tiết nhập kho
        String sql_ct;
        for (ModelKho data : list) {
            if (data.getSlTon() > 0) {
                sql_ct = "INSERT INTO ReceiptDetail(ID_Re,ID_Ing,Quantity) VALUES (?,?,?)";
                try (PreparedStatement p_ct = con.prepareStatement(sql_ct)) {
                    p_ct.setInt(1, pnk.getIdNK());
                    p_ct.setInt(2, data.getIdNL());
                    p_ct.setInt(3, data.getSlTon());
                    p_ct.execute();
                }
            }
        }
        p.close();
    }

    //Thêm phiếu xuất kho và chi tiết Xuất kho
    public void InsertPXK_CTXK(ModelPXK pxk, ArrayList<ModelKho> list) throws SQLException {
        //Thêm phiếu nhập kho
        String sql = "INSERT INTO Exportt(ID_Ex,ID_Emp,DateEx) VALUES (?,?,to_date(?, 'dd-mm-yyyy'))";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, pxk.getIdXK());
        p.setInt(2, pxk.getIdNV());
        p.setString(3, pxk.getNgayXK());
        p.execute();
        //Thêm chi tiết nhập kho
        String sql_ct;
        for (ModelKho data : list) {
            if (data.getSlTon() > 0) {
                sql_ct = "INSERT INTO ExportDetail(ID_Ex,ID_Ing,Quantity) VALUES (?,?,?)";
                PreparedStatement p_ct = con.prepareStatement(sql_ct);
                p_ct.setInt(1, pxk.getIdXK());
                p_ct.setInt(2, data.getIdNL());
                p_ct.setInt(3, data.getSlTon());
                p_ct.execute();
                p_ct.close();
            }
        }
        p.close();
    }

    //Lấy toàn bộ danh sách Khách Hàng
    public ArrayList<ModelKhachHang> MenuKH() throws SQLException {
        ArrayList<ModelKhachHang> list = new ArrayList<>();
        String sql = "SELECT ID_Cus, NameCus, to_char(DateJ,'dd-mm-yyyy') AS Day, Sales, AccumulatedPoin FROM Customer";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Cus = r.getInt(1);
            String NameCus = r.getString(2);
            String DateJ = r.getString(3);
            int Sales = r.getInt(4);
            int AccumulatedPoin = r.getInt(5);
            ModelKhachHang data = new ModelKhachHang(ID_Cus, NameCus, DateJ, Sales, AccumulatedPoin);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Điều chỉnh trạng thái bàn thành Đã đặt trước sau khi nhân viên xác nhận
    public void setTableReserve(int idBan) throws SQLException {
        String sql = "UPDATE Tablee SET Status = 'Reserved' WHERE ID_Table=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, idBan);
        p.execute();
        p.close();
    }

    //Hủy trạng thái bàn đã Đặt trước trước thành Còn trống
    public void CancelTableReserve(int idBan) throws SQLException {
        String sql = "UPDATE Tablee SET Status = 'Available' WHERE ID_Table=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, idBan);
        p.execute();
        p.close();
    }

    //Tìm hóa đơn có trạng thái Chưa thanh toán  dựa vào trạng mã Bàn
    public ModelHoaDon FindHoaDonbyID_Ban(ModelBan table) throws SQLException {
        ModelHoaDon hoadon = null;
        String sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-yyyy') AS Day,Price,Code_Voucher,MoneyReduced,Total,Status FROM Bill "
                + "WHERE ID_Table=? AND Status='Unpaid'";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, table.getID());
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Bill = r.getInt(1);
            int ID_Cus = r.getInt(2);
            int ID_Table = r.getInt(3);
            String DateBill = r.getString(4);
            int Price = r.getInt(5);
            String code_voucher = r.getString(6);
            int MoneyReduced = r.getInt(7);
            int Total = r.getInt(8);
            String Status = r.getString(9);
            hoadon = new ModelHoaDon(ID_Bill, ID_Cus, ID_Table, DateBill, Price, code_voucher, MoneyReduced, Total, Status);
        }
        r.close();
        p.close();
        return hoadon;
    }

    //Cập nhật trạng thái Hóa đơn thành Đã thanh toán khi Nhân viên xác nhận thanh toán
    public void UpdateHoaDonStatus(int idHD) throws SQLException {
        String sql = "UPDATE Bill SET Status = 'Paid' WHERE ID_Bill=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, idHD);
        p.execute();
        p.close();
    }

    //Lấy tên khách hàng từ Mã KH
    public String getTenKH(int idKH) throws SQLException {
        String name = "";
        String sql = "SELECT NameCus From Customer WHERE ID_Cus=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, idKH);
        ResultSet r = p.executeQuery();
        if (r.next()) {
            name = r.getString(1);
        }
        p.close();
        r.close();
        return name;
    }
}
