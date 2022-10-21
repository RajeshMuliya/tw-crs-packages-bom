<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="ExtranetWeb.Error" %>

<%@ Register Assembly="ExtranetWeb" Namespace="ExtranetWeb.App_Controls.CustomControls"
    TagPrefix="actl" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%--<link rel="SHORTCUT ICON" href="images/favicon.gif">--%>
<head id="Head1" runat="server">
    <title>Extranet</title>
</head>
<body>
    <form id="form1" runat="server">
    <table cellpadding="0" cellspacing="0" border="0" width="100%" class="Body-Pad">
        <tr>
            <td align="center">
                <table cellpadding="0" cellspacing="0" border="0" class="Page-Size">
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" class="Web-Width">
                                <tr>
                                    <td class="Header-Bg" valign="top">
                                        <table cellpadding="0" cellspacing="0" border="0" class="Web-Width">
                                            <tr>
                                                <td class="Logo-Pad Header-Bg" valign="middle">
                                                    <!--Logo here-->
                                                    <actl:Image ID="Image1" SkinID="Spacer" runat="server" />
                                                    <!--Logo here-->
                                                </td>
                                                <td valign="top" class="Pad-T10">
                                                    <table cellpadding="0" cellspacing="0" border="0" class="Web-Width">
                                                        <tr>
                                                            <td class="Pad-R8" align="right">
                                                                <!--Header Link Here-->
                                                                <actl:Button ID="btnNewLogout" runat="server" SkinID="LogOut" CausesValidation="false"
                                                                    OnClick="btnLogOut_Click" UseSubmitBehavior="false" Text="[Logout]" ForeColor="Black" />
                                                                <!--Header Link Here-->
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Header-Trip">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellpadding="0" cellspacing="0" border="0" class="Web-Width">
                                <tr>
                                    <td class="Page-Bg">
                                        <table border="0" cellspacing="0" cellpadding="0" align="center">
                                            <tr>
                                                <td height="50px">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="ErrorPageHeader">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <actl:Image ID="imgComments" runat="server" SkinID="Comment" />
                                                            </td>
                                                            <td class="Pad-L10">
                                                                <actl:Label ID="lblHeader" Text="[System Support]" ResourceName="lblHeader" ResourceBaseName="ExtranetWeb.Error"
                                                                    runat="server">
                                                                </actl:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Page-Section-Bg" align="center">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellpadding="5" cellspacing="0" class="Pad-8">
                                                                    <tr>
                                                                        <td>
                                                                            <actl:Image ID="imgInstruction" runat="server" SkinID="Bullet" />
                                                                        </td>
                                                                        <td class="Pad-L7" align="left">
                                                                            <actl:Label ID="lblInstruction" SkinID="NormalLabel" Text="[Sorry for the inconvenience. Some error has occurred while processing your request.]"
                                                                                ResourceName="lblInstruction" ResourceBaseName="ExtranetWeb.Error" runat="server">
                                                                            </actl:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <actl:Image ID="imgInstruction1" runat="server" SkinID="Bullet" />
                                                                        </td>
                                                                        <td class="Pad-L7" align="left">
                                                                            <actl:Label ID="lblInstruction1" SkinID="NormalLabel" Text="[An error report has been sent to the website administrator.]"
                                                                                ResourceName="lblInstruction1" ResourceBaseName="ExtranetWeb.Error" runat="server"></actl:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <actl:Image ID="imgInstruction2" runat="server" SkinID="Bullet" />
                                                                        </td>
                                                                        <td class="Pad-L7" align="left">
                                                                            <actl:Label ID="lblInstruction2" SkinID="NormalLabel" Text="[You can send us your feedback and report the same explicitly by sending us an email.]"
                                                                                ResourceName="lblInstruction2" ResourceBaseName="ExtranetWeb.Error" runat="server"></actl:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <actl:Image ID="imgInstruction3" runat="server" SkinID="Bullet" />
                                                                        </td>
                                                                        <td class="Pad-L7" align="left">
                                                                            <actl:Label ID="lblInstruction3" SkinID="NormalLabel" Text="[If you have any other concerns or comments about our site then also please let us know about the same.]"
                                                                                ResourceName="lblInstruction3" ResourceBaseName="ExtranetWeb.Error" runat="server"></actl:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <actl:Image ID="imgInstruction4" runat="server" SkinID="Bullet" />
                                                                        </td>
                                                                        <td class="Pad-L7" align="left">
                                                                            <actl:Label ID="lblInstruction4" SkinID="NormalLabel" Text="[We would like not only to hear about ways you think we can improve, but also if you had a good experience using our site.]"
                                                                                ResourceName="lblInstruction4" ResourceBaseName="ExtranetWeb.Error" runat="server"></actl:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <actl:Image ID="imgInstruction5" runat="server" SkinID="Bullet" />
                                                                        </td>
                                                                        <td class="Pad-L7" align="left">
                                                                            <actl:Label ID="lblInstruction5" SkinID="NormalLabel" Text="[We appreciate that you take the time to let us know your thoughts.]"
                                                                                ResourceName="lblInstruction5" ResourceBaseName="ExtranetWeb.Error" runat="server"></actl:Label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="50px">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr style="display: none">
                                    <td valign="top">
                                        <actl:Label ID="lblError" Font-Bold="true" SkinID="ErrorLabel" runat="server" Text="[Unknown error has occurred while processing the request.<br/> Kindly contact System Administrator for details of the error.
                                                                                                                                    Sorry for any inconvenience caused.]"></actl:Label>
                                        <actl:Label ID="lblHTMLError" Font-Bold="true" SkinID="ErrorLabel" runat="server"
                                            ResourceBaseName="HotelExtranetWeb.Error" ResourceName="lblHTMLError" runat="server"
                                            Text="[Values such as HTML tags or Scripting tags are not allowed.]" Visible="false"></actl:Label>
                                        <actl:Label ID="lblAccessDenied" Font-Bold="true" SkinID="RedData" runat="server"
                                            Text="[You do not have access to the page.]" Visible="false"></actl:Label>
                                        <br />
                                        <br />
                                        <actl:HyperLink Text="[Go Home]" Visible="false" runat="server" Style="font-weight: bold;
                                            font-size: medium;" ID="hypBack"></actl:HyperLink>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table class="Web-Width" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <!--Footer Starts Here-->
                                        <table cellpadding="0" cellspacing="0" border="0" class="Web-Width">
                                            <tr>
                                                <td class="Pad-8 Footer-Bg">
                                                    <!--Footer Text Starts Here-->
                                                    <actl:Label ID="lblFooter" runat="server" Text="[Copyright 2009-2010. Avani Cimcon Technologies All rights reserved | Powered byACT]"
                                                        ResourceName="lblFooter" ResourceBaseName="UserControlLibrary.App_Controls.UserControls.MainFooter"
                                                        SkinID="FooterText"></actl:Label>
                                                    <!--Footer Text ends Here-->
                                                </td>
                                            </tr>
                                        </table>
                                        <!--Footer ends Here-->
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
