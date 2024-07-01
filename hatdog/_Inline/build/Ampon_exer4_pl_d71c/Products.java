import java.sql.*;
public class Products {
	int pid;
	String pcat, pdesc, price, quantity, sdate;
	Connection con;
	Statement st;
	Resultset rs;

public Products (int pid, String pcat, String pdesc, String price, String quantity, String sdate){
	this.pid = pid;
	this.pcat = pcat;
	this.pdesc = pdesc;
	this.price = price;
	this.quantity = quantity;
	this.sdate = sdate;
	initialized();
}
	
private void initialized(){
	try
	{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/testdb?zeroDateTimeBehavior=convertToNull", "root", "root");
		st = con.createStatement();
	}
	catch (Exception ex)
	{
		System.out.println("Error: " + ex);
	}
}

public String insertData(){
	try
	{
		String query ="insert into products values('"+this.pid+"','"+this.pcat+"','"+this.pdesc+"','"+this.price+"','"+this.quantity+"','"+this.sdate+"')";
		st.executeUpdate(query);
	}
	catch (Exception ex)
	{
		System.out.println(ex);
	}
	return "Inserted";
}

public String[][] selectAllProducts(){
	String [][] resultArray = new String[0][];
	try
	{
		String query = "select * from products";
		rs = st.executeQuery(query);
		rs.last();
		int rowCount = rs.getRow();
		rs.beforeFirst();
		resultArray = new String[rowCount][6];
		int rowindex = 0;
		while (rs.next()){
			resultArray[rowindex][0] = rs.getString("pid");
			resultArray[rowindex][1] = rs.getString("pcat");
			resultArray[rowindex][2] = rs.getString("pdesc");
			resultArray[rowindex][3] = rs.getString("price");
			resultArray[rowindex][4] = rs.getString("quantity");
			resultArray[rowindex][5] = rs.getString("sdate");
			rowindex++;
		}
	}
	catch (SQLException ex)
	{
		System.out.println("Error executing query: " + ex);
	}
	return resultArray;
}

}
