<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Xml" %>

<script runat="server">
    private void UpdatePrice(object sender, EventArgs e)
    {
        XmlDocument document = new XmlDocument();

        document.Load(@"C:\Users\caoalviola\Desktop\webserver\Books.xml");

        XmlNodeList userNodes = document.SelectNodes("//bookstore/book");

        foreach(XmlNode userNode in userNodes)
        {
            float price = float.Parse(userNodes.Attributes["price"].Value);
            userNode.Attributes["price"].Value = (price + 1).ToString();
        }
        document.Save(@"C:\Users\caoalviola\Desktop\webserver\Books.xml");
    }

    private void ShowFname(object sender, EventArgs e)
    {
        XmlDocument document = new XmlDocument();

        document.Load(@"C:\Users\caoalviola\Desktop\webserver\Books.xml");

        XmlNodeList userNodes = document.SelectNodes("//bookstore/book/author/first-name");

        foreach(XmlNode item in nodes)
        {
           string res = items.InnerText;
           Response.Write(res + "<br>");
        }
        document.Save(@"C:\Users\caoalviola\Desktop\webserver\Books.xml");
    }

    private void InsertFname(object sender, EventArgs e)
    {
        XmlDocument document = new XmlDocument();

        document.Load(@"C:\Users\caoalviola\Desktop\webserver\Books.xml");

        XmlNode root = document.DocumentElement;
        XmlElement elem = document.CreateElement("book");

        elem.SetAttribute("genre", action);
        root.AppendChild(elem);
        elem.SetAttribute("price", "11.11");
        root.AppendChild(elem);

        XmlElement titlenode = document.CreateElement("title");

        titlenode.InnerText = "Avengers";

        elem.AppendChild(titlenode);

        document.Save(@"C:\Users\caoalviola\Desktop\webserver\Books.xml");

    }
</script>

<html>
    <body>
        <form runat="server">
            <input runat="server" id="button1" type="submit" values="View" OnServerClick="ShowFname"/>
            <input runat="server" id="button2" type="submit" values="update" OnServerClick="UpdateFname"/>
            <input runat="server" id="button3" type="submit" values="Insert" OnServerClick="InsertFname"/>
        </form>
    </body>
</html>