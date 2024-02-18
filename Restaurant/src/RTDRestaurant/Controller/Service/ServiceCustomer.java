package RTDRestaurant.Controller.Service;

import RTDRestaurant.Controller.Connection.DatabaseConnection;
import RTDRestaurant.Model.ModelCTHD;
import RTDRestaurant.Model.ModelMonAn;
import RTDRestaurant.Model.ModelKhachHang;
import RTDRestaurant.Model.ModelHoaDon;
import RTDRestaurant.Model.ModelVoucher;
import RTDRestaurant.Model.ModelBan;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import javax.swing.ImageIcon;

public class ServiceCustomer {

    private final Connection con;

    //Connect tới DataBase       
    public ServiceCustomer() {
        con = DatabaseConnection.getInstance().getConnection();
    }

    //Lấy toàn bộ danh sách Món ăn theo loại Món Ăn đang kinh doanh
    public ArrayList<ModelMonAn> MenuFood(String type) throws SQLException {
        ArrayList<ModelMonAn> list = new ArrayList<>();
        String sql = "SELECT ID_Dish,DishName,Price FROM Dish WHERE TypeD=? AND Status='are trading'";
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, type);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int id = r.getInt("ID_Dish");
            String name = r.getString("DishName");
            int value = r.getInt("Price");
            ModelMonAn data;
            if (id < 90) {
                data = new ModelMonAn(new ImageIcon(getClass().getResource("/Icons/Food/" + type + "/" + id + ".jpg")), id, name, value, type);
            } else {
                data = new ModelMonAn(new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")), id, name, value, type);
            }
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy danh sách Món ăn theo loại món ăn và thứ tự Tên/Giá tăng dần/Giá giảm dần đang kinh doanh
    public ArrayList<ModelMonAn> MenuFoodOrder(String type, String orderBy) throws SQLException {
        ArrayList<ModelMonAn> list = new ArrayList<>();

        String sql = "SELECT ID_Dish,DishName,Price FROM Dish WHERE TypeD=? AND Status='are trading'";
        switch (orderBy) {
            case "Name A->Z" -> {
                sql = "SELECT ID_Dish,DishName,Price FROM Dish WHERE TypeD=? AND Status='are trading' ORDER BY DishName";
            }
            case "Price Ascending" -> {
                sql = "SELECT ID_Dish,DishName,Price FROM Dish WHERE TypeD=? AND Status='are trading' ORDER BY Price";
            }
            case "Price Descending" -> {
                sql = "SELECT ID_Dish,DishName,Price FROM Dish WHERE TypeD=? AND Status='are trading' ORDER BY Price DESC";
            }
        }
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, type);

        ResultSet r = p.executeQuery();
        while (r.next()) {
            int id = r.getInt("ID_Dish");
            String name = r.getString("DishName");
            int value = r.getInt("Price");
            ModelMonAn data;
            if (id < 90) {
                data = new ModelMonAn(new ImageIcon(getClass().getResource("/Icons/Food/" + type + "/" + id + ".jpg")), id, name, value, type);
            } else {
                data = new ModelMonAn(new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")), id, name, value, type);
            }
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy toàn bộ danh sách bàn theo tầng
    public ArrayList<ModelBan> MenuTable(String floor) throws SQLException {
        ArrayList<ModelBan> list = new ArrayList<>();
        String sql = "SELECT ID_Table,TableName,Status FROM Tablee WHERE Locationn=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, floor);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int id = r.getInt("ID_Table");
            String name = r.getString("TableName");
            String status = r.getString("Status");
            ModelBan data = new ModelBan(id, name, status);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }
    //Lấy danh sách bàn theo trạng thái bàn Tất cả/Còn trống/Đã đặt trước/Đang dùng bữa

    public ArrayList<ModelBan> MenuTableState(String floor, String state) throws SQLException {
        ArrayList<ModelBan> list = new ArrayList<>();
        String sql = "SELECT ID_Table,TableName,Status FROM Tablee WHERE Locationn=?";
        switch (state) {
            case "All" ->
                sql = "SELECT ID_Table,TableName,Status FROM Tablee WHERE Locationn=?";
            case "Available" ->
                sql = "SELECT ID_Table,TableName,Status FROM Tablee WHERE Locationn=? AND Status='Available'";
            case "Reserved" ->
                sql = "SELECT ID_Table,TableName,Status FROM Tablee WHERE Locationn=? AND Status='Reserved'";
            case "Having a meal" ->
                sql = "SELECT ID_Table,TableName,Status FROM Tablee WHERE Locationn=? AND Status='Having a meal'";
        }
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, floor);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int id = r.getInt("ID_Table");
            String name = r.getString("TableName");
            String status = r.getString("Status");
            ModelBan data = new ModelBan(id, name, status);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy thông tin khách hàng từ ID người dùng
    public ModelKhachHang getCustomer(int userID) throws SQLException {
        ModelKhachHang data = null;
        String sql = "SELECT ID_Cus, NameCus, to_char(DateJ, 'dd-mm-yyyy') AS DateJ, Sales,AccumulatedPoin FROM Customer WHERE ID_User=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, userID);
        ResultSet r = p.executeQuery();
        while (r.next()) {

            int id = r.getInt("ID_Cus");
            String name = r.getString("NameCus");
            String date = r.getString("DateJ");
            int sales = r.getInt("Sales");
            int points = r.getInt("AccumulatedPoin");
            data = new ModelKhachHang(id, name, date, sales, points);
        }
        r.close();
        p.close();
        return data;
    }

    // Đổi tên Khách hàng 
    public void reNameCustomer(ModelKhachHang data) throws SQLException {
        String sql = "UPDATE Customer SET NameCus=? WHERE ID_Cus=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, data.getName());
        p.setInt(2, data.getID_KH());
        p.execute();
        p.close();
    }

    //Lấy toàn bộ danh sách Voucher
    public ArrayList<ModelVoucher> MenuVoucher() throws SQLException {
        ArrayList<ModelVoucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Voucher";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            String code = r.getString("Code_Voucher");
            String desc = r.getString("Describee");
            int percent = r.getInt("Percentt");
            String typeMenu = r.getString("TypeCode");
            int quantity = r.getInt("Quantity");
            int point = r.getInt("Poin");
            ModelVoucher data = new ModelVoucher(code, desc, percent, typeMenu, quantity, point);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy danh sách Voucher theo mốc xu
    public ArrayList<ModelVoucher> MenuVoucherbyPoint(String bypoint) throws SQLException {
        ArrayList<ModelVoucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Voucher";
        if (null != bypoint) {
            switch (bypoint) {
                case "All" ->
                    sql = "SELECT * FROM Voucher";
                case "Under 300 coins" ->
                    sql = "SELECT * FROM Voucher WHERE Poin <300";
                case "Between 300 and 500 coins" ->
                    sql = "SELECT * FROM Voucher WHERE Poin BETWEEN 300 AND 501";
                case "Over 500 coins" ->
                    sql = "SELECT * FROM Voucher WHERE Poin >500";
                default -> {
                }
            }
        }
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            String code = r.getString("Code_Voucher");
            String desc = r.getString("Describee");
            int percent = r.getInt("Percentt");
            String typeMenu = r.getString("TypeCode");
            int quantity = r.getInt("Quantity");
            int point = r.getInt("Poin");
            ModelVoucher data = new ModelVoucher(code, desc, percent, typeMenu, quantity, point);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    /*
        Khi khách hàng đặt bàn thì tự động thêm mới một hóa đơn với ID_Ban và ID_KH từ tham số 
        Tiền món ăn và Tiền giảm mặc định là 0
        Trạng thái Hóa đơn mặc định là Chưa thanh toán
     */
    public void InsertHoaDon(ModelBan table, ModelKhachHang customer) throws SQLException {
        //Tìm ID_HD tiếp theo
        int idHD=0;
        PreparedStatement p_ID=con.prepareStatement("SELECT MAX(ID_Bill) +1 FROM Bill");
        ResultSet r_id=p_ID.executeQuery();
        if(r_id.next()){
            idHD=r_id.getInt(1);
        }
       
        //Thêm Hoá Đơn mới
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-YYYY");
        String sql = "INSERT INTO Bill(ID_Bill,ID_Cus,ID_Table,DateBill,Price,MoneyReduced,Status)"
                + " VALUES (?,?,?,to_date(?, 'dd-mm-yyyy'),0,0,'Unpaid')";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, idHD);
        p.setInt(2, customer.getID_KH());
        p.setInt(3, table.getID());
        p.setString(4, simpleDateFormat.format(new Date()));
        p_ID.close();
        r_id.close();
        p.execute();
        p.close();

    }

    //Lấy thông tin HoaDon mà Khách hàng vừa đặt, Hóa Đơn có trạng thái 'Chưa thanh toán'
    public ModelHoaDon FindHoaDon(ModelKhachHang customer) throws SQLException {
        ModelHoaDon hoadon = null;
        String sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-yyyy') AS Day,Price,Code_Voucher,MoneyReduced,Total,Status FROM Bill "
                + "WHERE ID_Cus=? AND Status='Unpaid'";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, customer.getID_KH());
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

    //Thêm món ăn mới khách hàng vừa đặt vào CTHD
    public void InsertCTHD(int ID_Bill, int ID_Dish, int Quantity) throws SQLException {
        //Kiểm tra món ăn đã có trong CTHD hay chưa, nếu đã có cập nhật số lượng, nếu chưa thì thêm CTHD mới
        String sql = "SELECT 1 FROM BillDetail WHERE ID_Bill=? AND ID_Dish=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, ID_Bill);
        p.setInt(2, ID_Dish);
        ResultSet r = p.executeQuery();
        if (r.next()) {
            // Nếu tồn tại 
            String sql_update = "UPDATE BillDetail SET Quantity=Quantity+? WHERE ID_Bill=? AND ID_Dish=?";
            PreparedStatement p1 = con.prepareStatement(sql_update);
            p1.setInt(1, Quantity);
            p1.setInt(2, ID_Bill);
            p1.setInt(3, ID_Dish);
            p1.execute();
            p1.close();
        } else {
            //Nếu không tồn tại
            String sql_insert = "INSERT INTO BillDetail(ID_Bill,ID_Dish,Quantity) VALUES (?,?,?)";
            PreparedStatement p1 = con.prepareStatement(sql_insert);
            p1.setInt(1, ID_Bill);
            p1.setInt(2, ID_Dish);
            p1.setInt(3, Quantity);
            p1.execute();
            p1.close();
        }
        p.close();
        r.close();
    }

    // Lấy danh sách CTHD từ ID_HoaDon
    public ArrayList<ModelCTHD> getCTHD(int ID_Bill) throws SQLException {
        ArrayList<ModelCTHD> list = new ArrayList<>();
        String sql = "SELECT ID_Bill,BillDetail.ID_Dish, DishName,Quantity,Total FROM BillDetail "
                + "JOIN Dish ON Dish.ID_Dish=BillDetail.ID_Dish WHERE ID_Bill=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, ID_Bill);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_HD = r.getInt(1);
            int ID_MonAn = r.getInt(2);
            String tenMonAn = r.getString(3);
            int soluong = r.getInt(4);
            int thanhTien = r.getInt(5);
            ModelCTHD data = new ModelCTHD(ID_HD, ID_MonAn, tenMonAn, soluong, thanhTien);
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy toàn bộ danh sách hóa đơn của một khách hàng
    public ArrayList<ModelHoaDon> getListHD(int ID_KH) throws SQLException {
        ArrayList<ModelHoaDon> list = new ArrayList<>();
        String sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-yyyy') AS Day,Price,Code_Voucher,MoneyReduced,Total,Status FROM Bill "
                + "WHERE ID_Cus=? ORDER BY ID_Bill";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, ID_KH);
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
            ModelHoaDon hoadon = new ModelHoaDon(ID_Bill, ID_Cus, ID_Table, DateBill, Price, code_voucher, MoneyReduced, Total, Status);
            list.add(hoadon);
        }
        r.close();
        p.close();
        return list;
    }

    //Lấy toàn bộ danh sách hóa đơn của một khách hàng theo mốc Tổng tiền Hóa Đơn
    public ArrayList<ModelHoaDon> getListHDOrder(int ID_KH, String order) throws SQLException {
        ArrayList<ModelHoaDon> list = new ArrayList<>();
        String sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-yyyy') AS Day,Price,Code_Voucher,MoneyReduced,Total,Status FROM Bill "
                + "WHERE ID_Cus=? ORDER BY ID_Bill";
        switch (order) {
            case "All":
                sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-yyyy') AS Day,Price,Code_Voucher,MoneyReduced,Total,Status FROM Bill "
                        + "WHERE ID_Cus=? ORDER BY ID_Bill";
                break;
            case "Under 1,000,000 VND":
                sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-yyyy') AS Day,Price,Code_Voucher,MoneyReduced,Total,Status FROM Bill "
                        + "WHERE ID_Cus=? AND Total <1000000 ORDER BY ID_Bill";
                break;
            case "From 1 to 5,000,000 VND":
                sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-yyyy') AS Day,Price,Code_Voucher,MoneyReduced,Total,Status FROM Bill "
                        + "WHERE ID_Cus=? AND Total BETWEEN 1000000 AND 5000001 ORDER BY ID_Bill";
                break;
            case "Over 5,000,000 VND":
                sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-yyyy') AS Day,Price,Code_Voucher,MoneyReduced,Total,Status FROM Bill "
                        + "WHERE ID_Cus=? AND Total >5000000 ORDER BY ID_Bill";
                break;
            default:
                break;
        }
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, ID_KH);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int idHoaDon = r.getInt(1);
            int idKH = r.getInt(2);
            int idBan = r.getInt(3);
            String ngayHD = r.getString(4);
            int tienMonAn = r.getInt(5);
            String code_voucher = r.getString(6);
            int tienGiam = r.getInt(7);
            int tongtien = r.getInt(8);
            String trangthai = r.getString(9);
            ModelHoaDon hoadon = new ModelHoaDon(idHoaDon, idKH, idBan, ngayHD, tienMonAn, code_voucher, tienGiam, tongtien, trangthai);
            list.add(hoadon);
        }
        r.close();
        p.close();
        return list;
    }

    //Sau khi khách hàng đổi Voucher ở phần Điểm tích lũy, áp dụng trực tiếp lên hóa đơn mà khách hàng đang sử dụng
    //Thực hiện Trigger giảm Điểm tích lũy của Khách hàng và tính Tiền Giảm giá
    public void exchangeVoucher(int ID_HoaDon, String Code_Voucher) throws SQLException {
        String sql = "UPDATE Bill SET Code_Voucher=? WHERE ID_Bill=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, Code_Voucher);
        p.setInt(2, ID_HoaDon);
        p.execute();
        p.close();
    }
}
