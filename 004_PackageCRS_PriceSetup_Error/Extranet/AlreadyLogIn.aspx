<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AlreadyLogIn.aspx.cs" Inherits="ExtranetWeb.AlreadyLogIn" %>

<%@ Register Assembly="ExtranetWeb" Namespace="ExtranetWeb.App_Controls.CustomControls"
    TagPrefix="actl" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Already Logged in</title>
</head>
<body>
    <form id="form1" runat="server">
    <table border="0" cellpadding="0" cellspacing="0" class="Web-Width">
        <tr>
            <td align="center">
                <table border="0" cellspacing="0" cellpadding="0" class="Page-Size">
                    <tr>
                        <td class="Header-Bg" valign="middle">
                            <table cellpadding="0" cellspacing="0" border="0" class="Web-Width">
                                <tr>
                                    <td class="Logo-Pad Header-Bg" valign="middle">
                                        <!--Logo here-->
                                        <asp:Image ID="imgHeader" ImageUrl="images/spacer.gif" runat="server" />
                                        <!--Logo here-->
                                    </td>
                                    <td valign="top" class="Pad-T10">
                                        <table cellpadding="0" cellspacing="0" border="0" class="Web-Width">
                                            <tr>
                                                <td class="Pad-R8" align="right">
                                                    <!--Header Link Here-->
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <asp:Button ID="btnNewLogout" runat="server" CssClass="Header-Link" CausesValidation="false"
                                                                    OnClick="btnLogOut_Click" UseSubmitBehavior="false" Text="Logout" ForeColor="Black" />
                                                            </td>
                                                        </tr>
                                                    </table>
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
                    <tr>
                        <td class="Page-Bg">
                            <table border="0" cellpadding="0" cellspacing="0" class="Web-Width">
                                <tr>
                                    <td class="Pad-B50 Pad-T50 Error-Msg-Bold" align="center">
                                        <actl:Label ID="lblAlreadyLogIn" runat="server" Text="[Your attempt to log in to the system has landed here because there seems another already active log in from this browser]"
                                            ResourceBaseName="Extranetweb.AlreadyLogIn" ResourceName="lblAlreadyLogIn"></actl:Label>
                                        <br />
                                        <br />
                                        <actl:Label ID="lblAlreadyLogIn1" runat="server" Text="[Please logout of the system and try logging in again.]"
                                            ResourceBaseName="Extranetweb.AlreadyLogIn" ResourceName="lblAlreadyLogIn1"></actl:Label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
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
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
