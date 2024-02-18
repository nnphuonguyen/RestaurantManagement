package RTDRestaurant.Controller.Service;

import RTDRestaurant.Controller.Connection.DatabaseConnection;
import RTDRestaurant.Model.ModelChart;
import RTDRestaurant.Model.ModelHoaDon;
import RTDRestaurant.Model.ModelMonAn;
import RTDRestaurant.Model.ModelNhanVien;
import RTDRestaurant.Model.ModelPNK;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.swing.ImageIcon;

public class ServiceAdmin {

    private final Connection con;

    //Connect tới DataBase       
    public ServiceAdmin() {
        con = DatabaseConnection.getInstance().getConnection();
    }

    //Lấy toàn bộ danh sách nhân viên
    public ArrayList<ModelNhanVien> getListNV() throws SQLException {
        ArrayList<ModelNhanVien> list = new ArrayList();
        String sql = "SELECT ID_Emp,NameEmp,to_char(DateW,'dd-mm-yyyy')as Day,PhoneNum,Position,ID_Manager,Status FROM Employees";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Emp = r.getInt(1);
            String NameEmp = r.getString(2);
            String DateW = r.getString(3);
            String PhoneNum = r.getString(4);
            String Position = r.getString(5);
            int ID_Manager = r.getInt(6);
            String Status = r.getString(7);
            ModelNhanVien data = new ModelNhanVien(ID_Emp, NameEmp, DateW, PhoneNum, Position, ID_Manager, Status);
            list.add(data);
        }
        p.close();
        r.close();
        return list;
    }

    //Lấy thông tin nhân viên từ ID
    public ModelNhanVien getNV(int idNV) throws SQLException {
        ModelNhanVien data = null;
        String sql = "SELECT ID_Emp,NameEmp,to_char(DateW,'dd-mm-yyyy')as Day,PhoneNum,Position,ID_Manager,Status FROM Employees WHERE ID_Emp=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, idNV);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Emp = r.getInt(1);
            String NameEmp = r.getString(2);
            String DateW = r.getString(3);
            String PhoneNum = r.getString(4);
            String Position = r.getString(5);
            int ID_Manager = r.getInt(6);
            String Status = r.getString(7);
            data = new ModelNhanVien(ID_Emp, NameEmp, DateW, PhoneNum, Position, ID_Manager, Status);
        }
        p.close();
        r.close();
        return data;
    }

    //Lấy Mã nhân viên tiếp theo được thêm
    public int getNextID_NV() throws SQLException {
        int id = 0;
        String sql = "SELECT MIN(ID_Emp) +1 FROM Employees WHERE ID_Emp + 1 NOT IN (SELECT ID_Emp FROM Employees)";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        if (r.next()) {
            id = r.getInt(1);
        }
        return id;
    }

    //Thêm mới một nhân viên
    public void insertNV(ModelNhanVien data) throws SQLException {
        String sql = "INSERT INTO Employees(ID_Emp, NameEmp, DateW, PhoneNum, Position, ID_Manager, Status) VALUES (?,?,to_date(?,'dd-mm-yyyy'),?,?,?,'Working')";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, data.getId_NV());
        p.setString(2, data.getTenNV());
        p.setString(3, data.getNgayVL());
        p.setString(4, data.getSdt());
        p.setString(5, data.getChucvu());
        p.setInt(6, data.getId_NQL());
        p.execute();
        p.close();
    }

    //Sa thải một nhân viên, cập nhận tình trạng thành 'Da nghi viec'
    public void FireStaff(int ID_Emp) throws SQLException {
        String sql = "UPDATE Employees SET Status ='Has retired' WHERE ID_Emp=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, ID_Emp);
        p.execute();
        p.close();
    }

    //Cập nhật thông tin của một nhân viên
    public void UpdateNV(ModelNhanVien data) throws SQLException {
        String sql = "UPDATE Employees SET NameEmp=?,PhoneNum=?,Position=? WHERE ID_Emp=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, data.getTenNV());
        p.setString(2, data.getSdt());
        p.setString(3, data.getChucvu());
        p.setInt(4, data.getId_NV());
        p.execute();
        p.close();
    }

    //Lấy toàn bộ danh sách hóa đơn trong Tất cả/ngày/tháng/năm
    public ArrayList<ModelHoaDon> getListHDIn(String txt) throws SQLException {
        ArrayList<ModelHoaDon> list = new ArrayList();
        String sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-YYYY') as Day,Price,MoneyReduced,Total FROM Bill";
        if (txt.equals("All")) {
            sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-YYYY') as Day,Price,MoneyReduced,Total FROM Bill";
        } else if (txt.equals("Today")) {
            sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-YYYY') as Day,Price,MoneyReduced,Total FROM Bill "
                    + "WHERE TO_DATE(DateBill,'dd-mm-YYYY')=TO_DATE(CURRENT_DATE,'dd-mm-YYYY')";
        } else if (txt.equals("This Month")) {
            sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-YYYY') as Day,Price,MoneyReduced,Total FROM Bill "
                    + "WHERE EXTRACT(MONTH FROM DateBill)=EXTRACT(MONTH FROM CURRENT_DATE) AND EXTRACT(YEAR FROM DateBill)=EXTRACT(YEAR FROM CURRENT_DATE)";
        } else if (txt.equals("This Year")) {
            sql = "SELECT ID_Bill,ID_Cus,ID_Table,to_char(DateBill,'dd-mm-YYYY') as Day,Price,MoneyReduced,Total FROM Bill "
                    + "WHERE EXTRACT(YEAR FROM DateBill)=EXTRACT(YEAR FROM CURRENT_DATE) ";
        }
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int ID_Bill = r.getInt(1);
            int ID_Cus = r.getInt(2);
            int ID_Table = r.getInt(3);
            String DateBill = r.getString(4);
            int Price = r.getInt(5);
            int MoneyReduced = r.getInt(6);
            int Total = r.getInt(7);
            ModelHoaDon data = new ModelHoaDon(ID_Bill, ID_Cus, ID_Table, DateBill, Price, MoneyReduced, Total);
            list.add(data);
        }
        p.close();
        r.close();
        return list;
    }

    //Lấy tổng doanh thu Hóa Đơn trong ngày/tháng/năm
    public int getRevenueHD(String filter) throws SQLException {
        int revenue = 0;
        
        String sql = "SELECT SUM(Total) FROM Bill WHERE TO_DATE(DateBill,'dd-mm-YYYY')=TO_DATE(CURRENT_DATE,'dd-mm-YYYY')";
        if(filter.equals("Today")){
            sql = "SELECT SUM(Total) FROM Bill WHERE TO_DATE(DateBill,'dd-mm-YYYY')=TO_DATE(CURRENT_DATE,'dd-mm-YYYY')";
        }else if(filter.equals("This month")){
            sql = "SELECT SUM(Total) FROM Bill WHERE EXTRACT(MONTH FROM DateBill)=EXTRACT(MONTH FROM CURRENT_DATE) "
                    + "AND EXTRACT(YEAR FROM DateBill)=EXTRACT(YEAR FROM CURRENT_DATE)";
        }else if((filter.equals("This year"))){
            sql = "SELECT SUM(Total) FROM Bill WHERE EXTRACT(YEAR FROM DateBill)=EXTRACT(YEAR FROM CURRENT_DATE)";
        }
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        if (r.next()) {
            revenue = r.getInt(1);
        }
        p.close();
        r.close();
        return revenue;
    }
    //Lấy tổng doanh thu Hóa Đơn của tháng trước
    public int getPreMonthRevenueHD() throws SQLException {
        int Pre_revenue = 0;  
        String sql =  "SELECT SUM(Total) FROM Bill WHERE EXTRACT(MONTH FROM DateBill)=(EXTRACT(MONTH FROM CURRENT_DATE)-1) "
                    + "AND EXTRACT(YEAR FROM DateBill)=EXTRACT(YEAR FROM CURRENT_DATE)";
        
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        if (r.next()) {
            Pre_revenue = r.getInt(1);
        }
        p.close();
        r.close();
        return Pre_revenue;
    }
    

    //Lấy toàn bộ danh sách Phiếu Nhập Kho trong Tất cả/ngày/tháng/năm
    public ArrayList<ModelPNK> getListPNKIn(String txt) throws SQLException {
        ArrayList<ModelPNK> list = new ArrayList();
        String sql = "SELECT ID_Re,ID_Emp,to_char(DateRe,'dd-mm-yyyy') AS Day,Total FROM Receipt ORDER BY ID_Re";
        if (txt.equals("All")) {
            sql = "SELECT ID_Re,ID_Emp,to_char(DateRe,'dd-mm-yyyy') AS Day,Total FROM Receipt ORDER BY ID_Re";
        } else if (txt.equals("Today")) {
            sql = "SELECT ID_Re,ID_Emp,to_char(DateRe,'dd-mm-yyyy') AS Day,Total FROM Receipt "
                    + "WHERE TO_DATE(DateRe,'dd-mm-YYYY')=TO_DATE(CURRENT_DATE,'dd-mm-YYYY') ORDER BY ID_Re";
        } else if (txt.equals("This Month")) {
            sql = "SELECT ID_Re,ID_Emp,to_char(DateRe,'dd-mm-yyyy') AS Day,Total FROM Receipt "
                    + "WHERE EXTRACT(MONTH FROM DateRe)=EXTRACT(MONTH FROM CURRENT_DATE) AND EXTRACT(YEAR FROM DateRe)=EXTRACT(YEAR FROM CURRENT_DATE) ORDER BY ID_Re";
        } else if (txt.equals("This Year")) {
            sql = "SELECT ID_Re,ID_Emp,to_char(DateRe,'dd-mm-yyyy') AS Day,Total FROM Receipt "
                    + "WHERE EXTRACT(YEAR FROM DateRe)=EXTRACT(YEAR FROM CURRENT_DATE) ORDER BY ID_Re";
        }
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
        p.close();
        r.close();
        return list;
    }

    //Lấy tổng chi phí Nhập kho trong ngày/tháng/năm
    public int getCostNK(String filter) throws SQLException {
        int revenue = 0;
        
        String sql = "SELECT SUM(Total) FROM Receipt WHERE TO_DATE(DateRe,'dd-mm-YYYY')=TO_DATE(CURRENT_DATE,'dd-mm-YYYY')";
        if(filter.equals("Today")){
            sql = "SELECT SUM(Total) FROM Receipt WHERE TO_DATE(DateRe,'dd-mm-YYYY')=TO_DATE(CURRENT_DATE,'dd-mm-YYYY')";
        }else if(filter.equals("This Month")){
            sql = "SELECT SUM(Total) FROM Receipt WHERE EXTRACT(MONTH FROM DateRe)=EXTRACT(MONTH FROM CURRENT_DATE) "
                    + "AND EXTRACT(YEAR FROM DateRe)=EXTRACT(YEAR FROM CURRENT_DATE)";
        }else if((filter.equals("This Year"))){
            sql = "SELECT SUM(Total) FROM Receipt WHERE EXTRACT(MONTH FROM DateRe)=EXTRACT(MONTH FROM CURRENT_DATE)";
        }
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        if (r.next()) {
            revenue = r.getInt(1);
        }
        p.close();
        r.close();
        return revenue;
    }
    //Lấy tổng chi phí Nhập Kho của tháng trước
    public int getPreMonthCostNK() throws SQLException {
        int Pre_Cost = 0;  
        String sql =  "SELECT SUM(Total) FROM Receipt WHERE EXTRACT(MONTH FROM DateRe)=(EXTRACT(MONTH FROM CURRENT_DATE)-1) "
                    + "AND EXTRACT(YEAR FROM DateRe)=EXTRACT(YEAR FROM CURRENT_DATE)";
        
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        if (r.next()) {
            Pre_Cost = r.getInt(1);
        }
        p.close();
        r.close();
        return Pre_Cost;
    }

    //Lấy toàn bộ doanh thu, chi phí, lợi nhuận của từng tháng trong năm
    public ArrayList<ModelChart> getRevenueCostProfit_byMonth() throws SQLException{
        ArrayList<ModelChart> list=new ArrayList<>();
        String sql_Revenue="SELECT EXTRACT(MONTH FROM DateBill) as Month, SUM(Total) FROM Bill WHERE EXTRACT(YEAR FROM DateBill)=EXTRACT(YEAR FROM CURRENT_DATE) "
                + "GROUP BY EXTRACT(MONTH FROM DateBill) ORDER BY Month";
        String sql_Cost="SELECT EXTRACT(MONTH FROM DateBill) as Month, SUM(Total) FROM Bill WHERE EXTRACT(YEAR FROM DateBill)=EXTRACT(YEAR FROM CURRENT_DATE) "
                + "GROUP BY EXTRACT(MONTH FROM DateBill) ORDER BY Month";
        PreparedStatement p_R = con.prepareStatement(sql_Revenue);
        PreparedStatement p_C = con.prepareStatement(sql_Cost);
        ResultSet r_R=p_R.executeQuery();
        ResultSet r_C=p_C.executeQuery();
        while(r_R.next() && r_C.next()){
            int revenue=r_R.getInt(2);
            int expenses=r_C.getInt(2);
            int profit=revenue-expenses;
            ModelChart data=new ModelChart("Month "+r_R.getInt(1), new double[]{revenue,expenses,profit});
            list.add(data);
        }
        return list;
    }
    //Lấy toàn bộ danh sách Món ăn theo loại Món Ăn
    public ArrayList<ModelMonAn> getMenuFood() throws SQLException {
        ArrayList<ModelMonAn> list = new ArrayList<>();
        String sql = "SELECT ID_Dish,DishName,Price,TypeD,Status FROM Dish";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        while (r.next()) {
            int id = r.getInt("ID_Dish");
            String name = r.getString("DishName");
            int value = r.getInt("Price");
            String type = r.getString("TypeD");
            String state =r.getString("Status");
            ModelMonAn data;
            if (id < 90) {
                data = new ModelMonAn(new ImageIcon(getClass().getResource("/Icons/Food/" + type + "/" + id + ".jpg")), id, name, value, type,state);
            } else {
                data = new ModelMonAn(new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")), id, name, value, type,state);
            }
            list.add(data);
        }
        r.close();
        p.close();
        return list;
    }
    //Lấy số lượng món ăn đang kinh doanh
    public int getNumberFood_inBusiness() throws SQLException{
        int number=0;
        String sql="SELECT COUNT(*) FROM Dish WHERE Status='are trading'";
        PreparedStatement p=con.prepareStatement(sql);
        ResultSet r=p.executeQuery();
        if(r.next()){
            number=r.getInt(1);
        }
        return number;
    }
    //Lấy Mã Món Ăn tiếp theo được thêm
    public int getNextID_MA() throws SQLException {
        int id = 0;
        String sql = "SELECT MIN(ID_Dish) +1 FROM Dish WHERE ID_Dish + 1 NOT IN (SELECT ID_Dish FROM Dish)";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();
        if (r.next()) {
            id = r.getInt(1);
        }
        return id;
    }
    //Thêm mới một Món Ăn
    public void insertMA(ModelMonAn data) throws SQLException {
        String sql = "insert into Dish(ID_Dish,DishName,Price,TypeD,Status) values(?,?, ?,?,'are trading')";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, data.getId());
        p.setString(2, data.getTitle());
        p.setInt(3, data.getValue());
        p.setString(4, data.getType());
        p.execute();
        p.close();
    }
    //Ngưng kinh doanh một món ăn (Cập nhật TrangThai='Ngung kinh doanh')
    public void StopSell(int idMA) throws SQLException {
        String sql = "UPDATE Dish SET Status = 'stop business' WHERE ID_Dish=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, idMA);
        p.execute();
        p.close();
    }
    //Kinh doanh trở lại một món ăn (Cập nhật TrangThai='Dang kinh doanh')
    public void BackSell(int idMA) throws SQLException {
        String sql = "UPDATE Dish SET Status = 'are trading' WHERE ID_Dish=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, idMA);
        p.execute();
        p.close();
    }
    //Cập nhật thông tin của một Món ăn
    public void UpdateMonAn(ModelMonAn data) throws SQLException {
        String sql = "UPDATE Dish SET DishName=?,Price=?,TypeD=? WHERE ID_Dish=?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, data.getTitle());
        p.setInt(2, data.getValue());
        p.setString(3, data.getType());
        p.setInt(4, data.getId());
        p.execute();
        p.close();
    }
}
