<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="IronPython.Hosting" %>
<%@ Import Namespace="Microsoft.Scripting.Hosting" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<form id="form1" runat="server">
    <div>
        <h2>Exer 1</h2>
        <button type="submit" id="Button1" runat="server" onserverclick="Button1_Click">Fetch Data</button>
        </br></br>
        <div id="ResultDiv" runat="server"></div>
    </div>
	<div><a href="http://localhost/">Back</a></div>
</form>

<script runat="server">
    protected void Button1_Click(object sender, EventArgs e)
        {
            ScriptEngine engine = Python.CreateEngine();
            ScriptScope scope = engine.CreateScope();
            string pythonScript = @"
import clr
clr.AddReference('MySql.Data')
from MySql.Data.MySqlClient import MySqlConnection, MySqlCommand

def fetch_data():
    conn_str = 'server=localhost; user=root; database=testdb;port=3306;password=root'
    conn = MySqlConnection(conn_str)
    conn.Open()
    cmd = MySqlCommand('SELECT * FROM products', conn)
    reader = cmd.ExecuteReader()
    results = []
    while reader.Read():
            results.append((reader.GetString(0), reader.GetString(1), reader.GetString(2), reader.GetString(3), reader.GetString(4), reader.GetString(5), reader.GetString(6)))
    reader.Close()
    conn.Close()
    return results

data = fetch_data()
";

ScriptSource source = engine.CreateScriptSourceFromString(pythonScript);
source.Execute(scope);

dynamic data = scope.GetVariable("data");

XmlDocument document = new XmlDocument();
XmlDeclaration xmlDeclaration = document.CreateXmlDeclaration("1.0", "UTF-8", null);
document.AppendChild(xmlDeclaration);
XmlElement rootElement = document.CreateElement("productStore");
document.AppendChild(rootElement);
document.Save(@"C:\Users\heart\OneDrive\Desktop\webserver\products.xml");
document.Load(@"C:\Users\heart\OneDrive\Desktop\webserver\products.xml");

string html = "<table border='1'><tr><th>ID</th><th>Category</th><th>Description</th><th>Price</th><th>Quantity</th><th>Stock-In-Date</th><th>Picture</th></tr>";
    foreach(var cell in data)
    {
        
	
	html += "<tr><td>" + cell[0] + "</td><td>" + cell[1] + "</td><td>" + cell[2] + "</td><td>" + cell[3] + "</td><td>" + cell[4] + "</td><td>" + cell[5] + "</td><td><img src=" + "\\pics\\" + cell[6] + " style='height: 100px; width: 100px;'></td></tr>";


	
	XmlNode root = document.DocumentElement;

	XmlElement prod = document.CreateElement("product");
	root.AppendChild(prod);
	XmlElement pid = document.CreateElement("pid");
	pid.InnerText = cell[0];
	prod.AppendChild(pid);

	XmlElement pcat = document.CreateElement("pcat");
	pcat .InnerText = cell[1];
	prod.AppendChild(pcat);

	XmlElement pdesc = document.CreateElement("pdesc");
	pdesc.InnerText = cell[2];
	prod.AppendChild(pdesc);

	XmlElement price = document.CreateElement("price");
	price.InnerText = cell[3];
	prod.AppendChild(price);

	XmlElement quantity = document.CreateElement("quantity");
	quantity.InnerText = cell[4];
	prod.AppendChild(quantity);

	XmlElement date = document.CreateElement("date");
	date.InnerText = cell[5];
	prod.AppendChild(date);

	XmlElement picture = document.CreateElement("picture");
	picture.InnerText = cell[6];
	prod.AppendChild(picture);

        document.Save(@"C:\Users\heart\OneDrive\Desktop\webserver\products.xml");

    }
html += "</table>";
ResultDiv.InnerHtml = html;
        }
</script>