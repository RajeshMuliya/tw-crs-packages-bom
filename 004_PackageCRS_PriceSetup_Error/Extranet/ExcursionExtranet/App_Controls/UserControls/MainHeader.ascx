<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MainHeader.ascx.cs"
    Inherits="UserControlLibrary.App_Controls.UserControls.MainHeader" %>
<%@ Register Assembly="UserControlLibrary" Namespace="UserControlLibrary.App_Controls.CustomControls"
    TagPrefix="actl" %>
<table border="0" cellspacing="0" cellpadding="0" class="Web-Width">
    <tr>
        <td class="Header-Bg">
            <table cellpadding="0" cellspacing="0" border="0" class="Web-Width">
                <tr>
                    <td class="Logo-Pad Header-Bg" valign="middle" width="10%">
                        <!--Logo here-->
                        <actl:Image ID="Image1" SkinID="Spacer" runat="server" />
                        <!--Logo here-->
                    </td>
                    <td runat="server" id="tdBusinessName"  valign="middle" align="left">
                        <actl:Label ID="lblBusinessName" runat="server" SkinID="HeaderLabel"></actl:Label>
                    </td>
                    <td valign="top" class="Pad-T10">
                        <table cellpadding="0" cellspacing="0" border="0" class="Web-Width">
                            <tr>
                                <td class="Pad-R8" align="right">
                                    <!--Header Link Here-->
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <actl:Button ID="btnUserName" runat="server" Text="[User Name]" SkinID="MyAccount"
                                                    UseSubmitBehavior="false" CausesValidation="false" OnClick="btnUserName_Click">
                                                </actl:Button>
                                            </td>
                                            <td>
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td runat="server" id="tdChangePassword" style="display:none">
                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td class="Header_Sap">
                                                                        |
                                                                    </td>
                                                                    <td>
                                                                        <actl:Button ID="btnChangePassword" runat="server" Text="[Change Password]" SkinID="HeaderLink"
                                                                            ToolTip="[Change Password]" UseSubmitBehavior="false" CausesValidation="false"
                                                                            OnClick="btnChangePassword_Click" ForeColor="Black"></actl:Button>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <%--<td class="Header_Sap">
                                                            |
                                                        </td>
                                                        <td>
                                                            <actl:Button ID="btnNewLogout" runat="server" SkinID="LogOut" CausesValidation="false"
                                                                OnClick="btnLogOut_Click" UseSubmitBehavior="false" Text="Logout" />
                                                        </td>--%>
                                                        
                                                         <td runat="server" id="tdAdminLink">
                                                            <actl:Button ID="btnBackToAdmin" runat="server" Text="[Back to Admin]" 
                                                                ToolTip="[Back to Admin]" UseSubmitBehavior="false" CausesValidation="false"
                                                                OnClick="btnBackToAdmin_Click"></actl:Button>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <!--Header Link Here-->
                                </td>
                            </tr>
                            <tr id="Tr1" runat="server" visible="false">
                                <td class="Pad-T10 Pad-R8" align="right">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <%--<td runat="server" id="tdBusinessName">
                                                <actl:Label ID="lblBusinessName" runat="server" SkinID="HeaderLabel"></actl:Label>
                                            </td>--%>
                                            <td class="Header_Sap" runat="server" id="tdSeperator">
                                                |
                                            </td>
                                            <%--<td runat="server" id="tdAdminLink">
                                                <actl:Button ID="btnBackToAdmin" runat="server" Text="[Back to Admin]" SkinID="HeaderLink"
                                                    ToolTip="[Back to Admin]" UseSubmitBehavior="false" CausesValidation="false"
                                                    OnClick="btnBackToAdmin_Click"></actl:Button>
                                            </td>--%>
                                        </tr>
                                    </table>
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
