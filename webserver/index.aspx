<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="IronPython.Hosting" %>
<%@ Import Namespace="Microsoft.Scripting.Hosting" %> 
<%@ Import Namespace="MySql.Data.MySqlClient" %>

    <form id="form1" runat="server">
        <div>
            <h2>Run Python Script to Fetch MySQL Data</h2>
            <button type="submit" id="Button1" runat="server" onserverclick="Button1_Click">Fetch Data</button> <br /><br />
            <div id="ResultDiv" runat="server"></div>
        </div>
    </form>
    <script runat="server">

        protected void Button1_Click(object sender, EventArgs e)
            {
                ScriptEngine engine = Python.CreateEngine();
                ScriptScope scope= engine.CreateScope();
                string pythonScript = @"
import clr
clr.AddReference('MySql.Data')
from MySql.Data.MySqlClient import MySqlConnection, MySqlCommand
        
def fetch_data():
	conn_str = 'server=localhost; user=root;database=testdb; port=3306; password=root' 
	conn = MySqlConnection(conn_str)
	conn.Open()
	cmd = MySqlCommand('SELECT CONCAT('<products>', GROUP_CONCAT(CONCAT('<product>','<pid>', id, '</pid>','<pcategory>', pcat, '<pcategory>','<pdesc>', pdesc, '</pdesc>','<price>', price, '<price>','<stock_quantity>', quantity, '<stock_quantity>','<stock_in_date>', sdate, '<stock_in_date>', '<picture>', picture, '<picture>','</product>') SEPARATOR ''),'</products>') AS xml_output FROM products', conn)
	reader = cmd.ExecuteReader()
	results = []
	while reader.Read():
		results.append((reader.GetString(0), reader.GetString(1)))
	reader.Close()
	conn.Close()
	return results


data = fetch_data()
";

ScriptSource source = engine.CreateScriptSourceFromString(pythonScript);


dynamic data = scope.GetVariable("data");
        
string html = "<table border='1'><tr><th>Name</th><th>Position</th></tr>";
        foreach (var row in data)
        {
        html += "<tr><td><font color=red>" + row[0] + "</font></td><td>" + row[1] + "</td></tr>";
        } 
html += "</table>";
ResultDiv. InnerHtml = html;
    }
    </script>