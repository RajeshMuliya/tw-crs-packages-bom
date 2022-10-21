<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/App_MasterPages/Common.master"
    CodeBehind="ExcursionRateSchedule.aspx.cs" Inherits="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule" %>

<%@ Register Assembly="ExcursionExtranetWeb" Namespace="ExcursionExtranetWeb.App_Controls.CustomControls"
    TagPrefix="actl" %>
<%@ Register Src="~/App_Controls/UserControls/DateRange.ascx" TagName="DateRange"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AJX" %>
<%@ Register Assembly="EntitySpaces.Web" Namespace="EntitySpaces.Web" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageContent" runat="server">

    <script language="javascript" type="text/javascript" src="<%= Session["ProviderSiteURL"] %>/JavaScripts/Common.js"></script>

    <script language="javAscript" type="text/javascript" src="../JavaScripts/jquery-1.3.2.min.js"></script>

    <script language="javascript" type="text/javascript" src="../JavaScripts/jquery-1.3.2.min.js"></script>

    <script language="javascript" type="text/javascript">
        function fnShowHideHotDealRate() {
            var chkHotDeal = $("[id$='_chkHotDeal']");
            var chkLastMinuteDeal = $("[id$='_chkLastMinuteDeal']");
            if (chkHotDeal != null && chkLastMinuteDeal != null) {
                if ($("[id$='_hfBillingType']").length != 0 && $("[id$='_hfBillingType']").val() != '') {
                    if ($("[id$='_trHotDealPrice']")) {
                        if ($(chkHotDeal).is(":checked") || $(chkLastMinuteDeal).is(":checked")) {
                            //$("[id$='_trLastMinuteDeal']").show();

                            if ($("[id$='_hfBillingType']").val() == "per equipment") {
                                $("[id$='_trPerEquipmentHotDealRate']").show();
                            }
                            else {
                                $("[id$='_trHotDealPrice']").show();
                            }
                        }
                        else {
                            //$("[id$='_trLastMinuteDeal']").hide();
                            $("[id$='_chkLastMinuteDeal']").attr('checked', false);

                            if ($("[id$='_hfBillingType']").val() == "per equipment") {
                                $("[id$='_trPerEquipmentHotDealRate']").hide();
                                $("[id$='_txtHotDealPerEquipmentPrice']").val("0");
                            }
                            else {
                                $("[id$='_trHotDealPrice']").hide();
                                $("[id$='_txtHotDealAdultPrice']").val("0");
                                $("[id$='_txtHotDealChildPrice']").val("0");
                                $("[id$='_txtHotDealInfantPrice']").val("0");
                            }

                        }
                    }
                }
            }
        }
        function fnCheckHotDealPerPersonRate(source, args) {
            if ((($("[id$='_chkHotDeal']").is(":checked")) || ($("[id$='_chkLastMinuteDeal']").is(":checked"))) && ($("[id$='_hfBillingType']").val() == "per person")) {
                if (($("[id$='_txtHotDealAdultPrice']").length != 0 && $("[id$='_txtHotDealAdultPrice']").val() != 0) || ($("[id$='_txtHotDealChildPrice']").length != 0 && $("[id$='_txtHotDealChildPrice']").val() != 0) || ($("[id$='_txtHotDealInfantPrice']").length != 0 && $("[id$='_txtHotDealInfantPrice']").val() != 0)) {
                    args.IsValid = true;
                }
                else {
                    args.IsValid = false;
                }
            }
            else {
                args.IsValid = true;
            }
        }

        function fnCheckHotDealPerEquipmentRate(source, args) {
            if ((($("[id$='_chkHotDeal']").is(":checked")) || ($("[id$='_chkLastMinuteDeal']").is(":checked"))) && ($("[id$='_hfBillingType']").val() == "per equipment")) {
                if ($("[id$='_txtHotDealPerEquipmentPrice']").length != 0 && $("[id$='_txtHotDealPerEquipmentPrice']").val() != 0) {
                    args.IsValid = true;
                }
                else {
                    args.IsValid = false;
                }
            }
            else {
                args.IsValid = true;
            }
        }
        function fnCheckRateDate(sender, e) {
            if ($("[id$='_txtDateFrom']").length != 0) {
                var compareFromDateID = $("[id$='_txtDateFrom']").attr("id");
                var compareToDate = $("[id$='_txtDateTo']").attr("id");

                var toDate = fnDateCompare(compareFromDateID, "<%= txtRateDateFrom.ClientID %>");
                var fromDate = fnDateCompare("<%= txtRateDateFrom.ClientID %>", compareToDate);
                if (toDate == true && fromDate == true) {
                    e.IsValid = true;
                }
                else {
                    e.IsValid = false;
                }
            }
            else {
                e.IsValid = false;
            }
        }

        function fnDateCompare(fromDateId, toDateId) {
            try {

                var shortDateFormat = $('.ShortDateFormat').html();
                Date.format = shortDateFormat;
                Date.format = Date.format.toLowerCase();

                var txtFromDate = document.getElementById(fromDateId);
                var txtToDate = document.getElementById(toDateId);
                var fromDate = new Date(Date.fromString(txtFromDate.value));
                var toDate = new Date(Date.fromString(txtToDate.value));

                if (fromDate > toDate) {
                    return false;
                }
                else {
                    return true;
                }
            }
            catch (e) {
            }
            return true;
        }

        function fnCheckRateFromToDate(sender, e) {
            if ($("[id$='_txtRateDateFrom']").length != 0) {
                var compareFromDateID = $("[id$='_txtRateDateFrom']").attr("id");
                var compareToDate = $("[id$='_txtDateTo']").attr("id");
                var toDate = fnDateCompare(compareFromDateID, "<%= txtRateToDate.ClientID %>");
                var fromDate = fnDateCompare("<%= txtRateToDate.ClientID %>", compareToDate);
                if (toDate == true && fromDate == true) {
                    e.IsValid = true;
                }
                else {
                    e.IsValid = false;
                }

            }
            else {
                e.IsValid = true;
            }
        }
        function fnCheckMaxAdultsQuantity(sender, e) {
            if (($("[id$='_txtAdultPrice']").length != 0) && ($("[id$='_txtAdultMaxQty']").length != 0)) {
                if ($("[id$='_txtAdultPrice']").val() > 0 && $("[id$='_txtAdultMaxQty']").val() == 0) {
                    e.IsValid = false;
                }
                else {
                    e.IsValid = true;
                }

            }
            else {
                e.IsValid = true;
            }
        }
        function fnCheckMaxEquipmentQuantity(sender, e) {
            if (($("[id$='_txtPrice']").length != 0) && ($("[id$='_txtEquipmentMaxQty']").length != 0)) {
                if ($("[id$='_txtPrice']").val() > 0 && $("[id$='_txtEquipmentMaxQty']").val() == 0) {
                    e.IsValid = false;
                }
                else {
                    e.IsValid = true;
                }

            }
            else {
                e.IsValid = true;
            }
        }

        function fnCheckMaxChildQuantity(sender, e) {
            if (($("[id$='_txtChildPrice']").length != 0) && ($("[id$='_txtChildMaxQty']").length != 0)) {
                if ($("[id$='_txtChildPrice']").val() > 0 && $("[id$='_txtChildMaxQty']").val() == 0) {
                    e.IsValid = false;
                }
                else {
                    e.IsValid = true;
                }

            }
            else {
                e.IsValid = false;
            }
        }
        function fnCheckMaxInfantQuantity(sender, e) {
            if (($("[id$='_txtInfantPrice']").length != 0) && ($("[id$='_txtInfantMaxQty']").length != 0)) {
                if ($("[id$='_txtInfantPrice']").val() > 0 && $("[id$='_txtInfantMaxQty']").val() == 0) {
                    e.IsValid = false;
                }
                else {
                    e.IsValid = true;
                }

            }
            else {
                e.IsValid = false;
            }
        }
        function fnCheckRatePersonRate(source, args) {
            if (($("[id$='_txtAdultPrice']").length != 0 && $("[id$='_txtAdultPrice']").val() != 0) || ($("[id$='_txtChildPrice']").length != 0 && $("[id$='_txtChildPrice']").val() != 0) || ($("[id$='_txtInfantPrice']").length != 0 && $("[id$='_txtInfantPrice']").val() != 0)
                || ($("[id$='_txtSingleAdultPrice']").length != 0 && $("[id$='_txtSingleAdultPrice']").val() != 0)
                || ($("[id$='_txtExtraAdult']").length != 0 && $("[id$='_txtExtraAdult']").val() != 0)
                || ($("[id$='_txtChildWithOutBed']").length != 0 && $("[id$='_txtChildWithOutBed']").val() != 0)) {
                args.IsValid = true;
            }
            else {
                args.IsValid = false;
            }
        }
        function fnCheckRateEquipmentRate(source, args) {
            if ($("[id$='_txtPrice']").length != 0 && $("[id$='_txtPrice']").val() != 0) {
                args.IsValid = true;
            }
            else {
                args.IsValid = false;
            }
        }
        function fnCopyData(sourceControlID, destinationControlID) {
            var sourceControl = document.getElementById(sourceControlID);
            var destinationControl = document.getElementById(destinationControlID);
            if (sourceControl != null && destinationControl != null) {
                destinationControl.value = "";
                destinationControl.value = sourceControl.value;
            }
        }
        function SetTodaysDate(sender, args) {
            var serverDate = document.getElementById('<%= hfServerDateInUsFormat.ClientID %>');
            if (serverDate != null && serverDate.value != '') {
                var d = new Date(serverDate.value);
                sender.set_todaysDate(d);
            }
        }
        //Added by Suman Rajpura for client side change of Duration label value.
        function GetDurationType() {
            var DurationType;
            var DurationType = $("[id$='_hfDurationDesc']").val();
            var PersentDurationType_array = DurationType.split(",");
            if ($("[id$='_rdbDays']").is(":checked")) {
                $("[id$='_lblDesc']").html(PersentDurationType_array[0]);
            }
            else if ($("[id$='_rdbHours']").is(":checked")) {
                $("[id$='_lblDesc']").html(PersentDurationType_array[1]);
            }
            else if ($("[id$='_rdbMinutes']").is(":checked")) {
                $("[id$='_lblDesc']").html(PersentDurationType_array[2]);
            }
        }
        //End Added by Suman Rajpura for client side change of Duration label value.
    </script>

    <asp:ScriptManagerProxy ID="scriptManagerRates" runat="server">
    </asp:ScriptManagerProxy>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td class="Page-Title">
                <actl:Label BusinessName="true" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                    ResourceName="lbltblHeader" ID="lbltblHeader" runat="server" Text="[Cofigure Rates and Schedule]">
                </actl:Label>
            </td>
        </tr>
        <tr style="display: none">
            <td align="left">
                <actl:Label ID="lblWarning" runat="server" ResourceName="lblWarning" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                    SkinID="NormalLabel" Text="[!!!Attention!!!<br />NOTE: The changes made here would be seen by the user on Booking engine when you save them. Please ensure double check the entries before Saving them.]">
                </actl:Label>
            </td>
        </tr>
        <!-- For Configre Schedule -->
        <tr>
            <td class="Pad-T10">
                <table cellpadding="0" cellspacing="0" border="0" class="Web-Width">
                    <tr>
                        <td class="Page-Sub-Section-Title">
                            <actl:Label BusinessName="true" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                ResourceName="lblConfigureSchedule" ID="lblConfigureSchedule" runat="server"
                                Text="[Configure Schedules]">
                            </actl:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="Page-Section-Bg Page-Section-Bg-List">
                            <table cellpadding="0" cellspacing="0" border="0" class="Web-Width Pad-8">
                                <tr>
                                    <td>
                                        <actl:ValidationSummary ID="valSumRateAndSchedule" runat="server" DisplayMode="BulletList" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <actl:Label ID="lblSuccess" runat="server" SkinID="SuccessLabel"></actl:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <actl:Label ID="lblActivityNameID" Visible="false" runat="server">
                                        </actl:Label>
                                        <actl:Label ID="lblActivitySeasonID" Visible="false" runat="server">
                                        </actl:Label>
                                        <actl:Label ID="lblActivityRateID" Visible="false" runat="server">
                                        </actl:Label>
                                        <actl:Label ID="lblPersonRateID" Visible="false" runat="server">
                                        </actl:Label>
                                        <actl:Label ID="lblChildRateID" Visible="false" runat="server">
                                        </actl:Label>
                                        <actl:Label ID="lblInfantRateID" Visible="false" runat="server">
                                        </actl:Label>
                                        <actl:Label ID="lblSingleAdultRateID" Visible="false" runat="server">
                                        </actl:Label>
                                        <actl:Label ID="lblExtraAdultRateID" Visible="false" runat="server">
                                        </actl:Label>
                                        <actl:Label ID="lblExtraChildWithoutBedRateID" Visible="false" runat="server">
                                        </actl:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td align="left">
                                                    <actl:Label ID="lblActivityName" SkinID="LabelBold" BusinessName="true" ResourceName="lblActivityName"
                                                        runat="server" Text="[Activity Name]  :">
                                                    </actl:Label>
                                                    <actl:HiddenField ID="hfBillingType" runat="Server"></actl:HiddenField>
                                                </td>
                                                <td class="Pad-L7" align="left">
                                                    <actl:Label ID="lblActivityValue" ResourceName="lblActivityValue" SkinID="NormalLabel"
                                                        runat="server">
                                                    </actl:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr style="display: none">
                                    <td>
                                        <actl:Label ID="lblNote" runat="server" SkinID="NormalLabel" ResourceName="lblNote"
                                            Text="[Enter the date range for which the activity will be available to the customer].">
                                        </actl:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Pad-T10">
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td valign="top" align="left">
                                                    <uc1:DateRange ID="UCDateRange" runat="server" IsToDateRequiredField="true" IsToFromRequiredField="true"
                                                        IsFromDateReadOnly="false" IsToDateReadOnly="false" ShowTodayInFromDate="true"
                                                        ShowTodayInToDate="true" />
                                                </td>
                                                <td valign="top" align="left" class="Pad-L7">
                                                    <actl:CustomValidator ID="custValDateRange" runat="server" ResourceName="custValDateRange"
                                                        ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                        OnServerValidate="custValDateRange_ServerValidate" ErrorMessage="[Duplicate Date range found. Please enter another date range.]">
                                                    </actl:CustomValidator>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Pad-T10">
                                        <table border="0" cellpadding="0" cellspacing="0" class="Web-Width">
                                            <tr>
                                                <td align="left" width="25%">
                                                    <actl:Label ID="lblDuration" BusinessName="true" ResourceName="lblDuration" SkinID="LabelBold"
                                                        runat="server" Text="[Enter the Duration of the Activity]">
                                                    </actl:Label>
                                                    <actl:HiddenField ID="hfDurationDesc" runat="server" />
                                                </td>
                                                <td align="left">
                                                    <table cellspacing="0" cellpadding="0" border="0">
                                                        <tr>
                                                            <td class="Pad-L5">
                                                                <actl:RadioButton ID="rdbDays" ResourceName="rdbDays" runat="server" Text="[Days]"
                                                                    Checked="true" onclick="GetDurationType();" GroupName="daysHours" />
                                                            </td>
                                                            <td class="Pad-L7">
                                                                <actl:RadioButton ID="rdbHours" ResourceName="rdbHours" GroupName="daysHours" runat="server"
                                                                    Text="[Hours]" onclick="GetDurationType();" />
                                                            </td>
                                                            <td class="Pad-L7">
                                                                <actl:RadioButton ID="rdbMinutes" runat="server" ResourceName="rdbMinutes" GroupName="daysHours"
                                                                    Text="[Minutes]" onclick="GetDurationType();" />
                                                            </td>
                                                            <td class="Pad-L7">
                                                                <actl:TextBox ID="txtDuration" runat="server" MaxLength="3" SkinID="MandatoryTextBox"
                                                                    Width="50px"></actl:TextBox>
                                                            </td>
                                                            <td class="Pad-L2">
                                                                <actl:RequiredFieldValidator ID="reqValDuration" Display="Dynamic" runat="server"
                                                                    ResourceName="reqValDuration" ControlToValidate="txtDuration" ErrorMessage="[Please enter Duration]."></actl:RequiredFieldValidator>
                                                            </td>
                                                            <td class="Pad-L2">
                                                                <actl:RegularExpressionValidator ID="regExpValDuration" ValidationExpression="([0-9])*"
                                                                    Display="Dynamic" runat="server" ControlToValidate="txtDuration" ResourceName="regExpValDuration"
                                                                    ErrorMessage="[Duration - Please enter numeric only]." />
                                                            </td>
                                                            <td class="Pad-L7">
                                                                <actl:Label ID="lblDesc" SkinID="NormalLabel" runat="server"></actl:Label>
                                                            </td>
                                                            <td class="Pad-L7">
                                                                <actl:Button ID="btnManageInclusion" runat="server" Text="[Manage Inclusion]" Style="display: none" OnClick="btnManageInclusion_Click" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr id="trCommission" runat="server" visible="false">
                                                <td class="Pad-T10">
                                                    <actl:Label ID="lblCommossion" runat="server" SkinID="LabelBold" ResourceName="lblCommossion"
                                                        ResourceBaseName="HotelExtranetWeb.MemberAdmin.Allocation" Text="[Commission]"></actl:Label>
                                                </td>
                                                <td class="Pad-T10 Pad-L5">
                                                    <table border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                                <actl:RadioButton ID="rbPercentageCommossion" runat="server" ResourceName="rbPercentageCommossion"
                                                                    ResourceBaseName="HotelExtranetWeb.MemberAdmin.Allocation" Text="[In %]" GroupName="CommissionType"
                                                                    Checked="true" />
                                                            </td>
                                                            <td class="Pad-L7">
                                                                <actl:RadioButton ID="rbFixedCommossion" runat="server" Text="[In ##CurrencyCode##]"
                                                                    GroupName="CommissionType" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr id="trCommissionAmmount" runat="server" visible="false">
                                                <td class="Pad-T10">
                                                    <actl:Label ID="lblCommissionAmount" runat="server" SkinID="LabelBold" ResourceName="CommissionAmount"
                                                        ResourceBaseName="VehicleExtranetWeb.MemberAdmin.AddEditVehicleCategory" Text="[Commission Amount]"></actl:Label>
                                                </td>
                                                <td class="Pad-T10 Pad-L5">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left">
                                                                <actl:TextBox ID="txtCommission" Width="75px" runat="server" MaxLength="9" Style="text-align: right;"
                                                                    SkinID="MandatoryTextBox"></actl:TextBox>
                                                            </td>
                                                            <td align="left" class="Pad-L7">
                                                                <actl:CustomValidator ID="custValCommission" ResourceBaseName="VehicleExtranetWeb.MemberAdmin.VehicleCategory"
                                                                    ResourceName="custValCommission" ErrorMessage="[Commission - Please enter numeric value. In case of commission type percentage more than 100 is not allowed.]"
                                                                    runat="server" ClientValidationFunction="fnValidateCommission" ControlToValidate="txtCommission"
                                                                    Display="Dynamic">
                                                                </actl:CustomValidator>
                                                            </td>
                                                            <td align="left" class="Pad-L7">
                                                                <actl:CustomValidator ID="custValCommissionNumeric" ResourceBaseName="VehicleExtranetWeb.MemberAdmin.VehicleCategory"
                                                                    ResourceName="custValCommission" ErrorMessage="[Commission - Please enter numeric value. In case of commission type percentage more than 100 is not allowed.]"
                                                                    runat="server" ClientValidationFunction="custValRateTextBox" ControlToValidate="txtCommission"
                                                                    Display="Dynamic">
                                                                </actl:CustomValidator>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr id="trPerEquipment" runat="server">
                                                <td class="Pad-T10" align="left">
                                                    <actl:Label ID="lblEquipmentName" runat="server" SkinID="LabelBold" Text="[Equipment Name]"
                                                        ResourceName="lblEquipmentName">
                                                    </actl:Label>
                                                </td>
                                                <td class="Pad-T10 Pad-L7" align="left">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <actl:TextBox ID="txtEquipment" SkinID="MandatoryTextBox" runat="server" MaxLength="50">
                                                                </actl:TextBox>
                                                            </td>
                                                            <td class="Pad-L5">
                                                                <actl:RequiredFieldValidator ID="reqValEquipmentName" ResourceName="reqValEquipmentName"
                                                                    runat="server" ControlToValidate="txtEquipment" ErrorMessage="[Please enter Equipment Name].">
                                                                </actl:RequiredFieldValidator>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr style="display: none;">
                                                <td class="Pad-T10" align="left">
                                                    <actl:Label ID="lblIndicativeRate" ResourceName="lblIndicativeRate" runat="server"
                                                        Text="[Indicative Rate]" SkinID="LabelBold">
                                                    </actl:Label>
                                                </td>
                                                <td class="Pad-T10 Pad-L7" align="left">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left">
                                                                <actl:TextBox ID="txtIndicativeRate" runat="server" SkinID="MandatoryTextBox" MaxLength="12"
                                                                    Text="1">
                                                                </actl:TextBox>
                                                            </td>
                                                            <td class="Pad-L5" align="left">
                                                                <actl:RequiredFieldValidator ID="reqValIndicativeRate" ResourceName="reqValIndicativeRate"
                                                                    runat="server" ControlToValidate="txtIndicativeRate" ErrorMessage="[Please enter Indicative Rate.]">
                                                                </actl:RequiredFieldValidator>
                                                            </td>
                                                            <td class="Pad-L2" align="left">
                                                                <actl:CompareValidator ID="compValIndicativeRate" runat="server" ControlToValidate="txtIndicativeRate"
                                                                    Display="Dynamic" ErrorMessage="[Indicative Rate - Please enter numeric only.]"
                                                                    Operator="DataTypeCheck" ResourceName="compValIndicativeRate" Type="Currency"
                                                                    SetFocusOnError="true">
                                                                </actl:CompareValidator>
                                                            </td>
                                                            <%--<td class="Pad-L2" align="left">
                                                                <actl:CompareValidator ID="compValIndicativeRate1" runat="server" ControlToValidate="txtIndicativeRate"
                                                                    Display="Dynamic" ErrorMessage="[Please Enter Indicative Price greater than 0]"
                                                                    Type="Currency" ResourceName="compValIndicativeRate1" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                    ValueToCompare="0" Operator="LessThan" SetFocusOnError="true">
                                                                </actl:CompareValidator>
                                                            </td>--%>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr style="display: none">
                                                <td align="left" valign="top" class="Pad-T10">
                                                    <actl:Label ID="lblIsHotDeal" SkinID="LabelBold" BusinessName="true" ResourceName="lblIsHotDeal"
                                                        runat="server" Text="[Mark activity as ]">
                                                    </actl:Label>
                                                </td>
                                                <td class="Pad-T10">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="Pad-L7">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td valign="top" align="left">
                                                                            <actl:CheckBox ID="chkHotDeal" runat="server" onclick="fnShowHideHotDealRate();" />
                                                                        </td>
                                                                        <td align="left" valign="top" class="Pad-L5">
                                                                            <actl:Label ID="lblHotDeal" SkinID="LabelBold" ResourceName="lblHotDeal" runat="server"
                                                                                Text="[Hot deal]">
                                                                            </actl:Label>
                                                                        </td>
                                                                        <td align="left" valign="top" class="Pad-L20">
                                                                            <actl:CheckBox ID="chkLastMinuteDeal" onclick="fnShowHideHotDealRate();" runat="server" />
                                                                        </td>
                                                                        <td align="left" valign="top" class="Pad-L5">
                                                                            <actl:Label ID="lblIsLastMinuteDeal" ResourceName="lblIsLastMinuteDeal" runat="server"
                                                                                Text="[Last minute deal]" SkinID="LabelBold">
                                                                            </actl:Label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr runat="server" id="trHotDealPrice" style="display: none">
                                                <td class="Pad-T10"></td>
                                                <td class="Pad-T10">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left" valign="top" class="Pad-L7">
                                                                <actl:Label ID="lblHotDealRate" SkinID="LabelBold" ResourceName="lblHotDealRate"
                                                                    runat="server" Text="[Rate]">
                                                                </actl:Label>
                                                            </td>
                                                            <td class="Pad-L20" align="left">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td valign="top" align="left">
                                                                            <actl:Label ID="lblHotDealCategoryHeader" SkinID="LabelBold" ResourceName="lblCategory"
                                                                                runat="server" Text="[Category]">
                                                                            </actl:Label>
                                                                        </td>
                                                                        <td valign="top" align="left">
                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                <tr>
                                                                                    <td align="left" class="Pad-L7" valign="top">
                                                                                        <actl:Label ID="lblHotDealRateHeader" SkinID="LabelBold" runat="server" Text="[Price (in ##currencycode##)]">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <td align="left" class="Pad-L5" valign="top">
                                                                                        <actl:CustomValidator ID="custValHotDealRatePerPerson" runat="server" ValidateEmptyText="true"
                                                                                            ErrorMessage="[Hot Deal Rate - Please enter price for atleast one category.]"
                                                                                            ResourceName="custValHotDealRatePerPerson" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                            ClientValidationFunction="fnCheckHotDealPerPersonRate" Display="Dynamic">
                                                                                        </actl:CustomValidator>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Pad-T10">
                                                                            <actl:Label ID="lblHotDealAdult" CssClass="Label" runat="server" ResourceName="lblAdult"
                                                                                Text="[Per Adult]">
                                                                            </actl:Label>
                                                                        </td>
                                                                        <td class="Pad-T10" align="left">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr>
                                                                                    <td class="Pad-L7">
                                                                                        <actl:TextBox ID="txtHotDealAdultPrice" SkinID="MandatoryTextBox" runat="server"
                                                                                            MaxLength="19" Text="0">
                                                                                        </actl:TextBox>
                                                                                    </td>
                                                                                    <td class="Pad-L5">
                                                                                        <actl:RequiredFieldValidator ID="reqValHotDealAdultPrice" ControlToValidate="txtHotDealAdultPrice"
                                                                                            runat="server" ResourceName="reqValHotDealAdultPrice" Display="Dynamic" ErrorMessage="[Hot Deal Rate for Adults - Please enter rate.]">
                                                                                        </actl:RequiredFieldValidator>
                                                                                    </td>
                                                                                    <%--<td class="Pad-L2">
                                                                                        <actl:CompareValidator ID="compValHotDealAdultPrice" runat="server" ControlToValidate="txtHotDealAdultPrice"
                                                                                            Display="Dynamic" ErrorMessage="[Hot Deal Rate for Adults - Please enter numeric value.]"
                                                                                            Operator="DataTypeCheck" ResourceName="compValHotDealAdultPrice" Type="Currency">
                                                                                        </actl:CompareValidator>
                                                                                    </td>--%>
                                                                                    <td class="Pad-L2">
                                                                                        <actl:CustomValidator ID="custValTxtHDAdultPrice" ResourceName="compValHotDealAdultPrice"
                                                                                            ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                            runat="server" ControlToValidate="txtHotDealAdultPrice" ClientValidationFunction="custValRateTextBox"
                                                                                            ErrorMessage="[Hot Deal Rate for Adults - Please enter numeric value.]" Display="Dynamic"> </actl:CustomValidator>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Pad-T10">
                                                                            <actl:Label ID="lblHotDealChild" CssClass="Label" runat="server" ResourceName="lblChild"
                                                                                Text="[Per Child]">
                                                                            </actl:Label>
                                                                        </td>
                                                                        <td class="Pad-T10">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr>
                                                                                    <td class="Pad-L7" align="left">
                                                                                        <actl:TextBox ID="txtHotDealChildPrice" SkinID="MandatoryTextBox" runat="server"
                                                                                            MaxLength="19" Text="0">
                                                                                        </actl:TextBox>
                                                                                    </td>
                                                                                    <td class="Pad-L5" align="left">
                                                                                        <actl:RequiredFieldValidator ID="reqValHotDealChildPrice" ControlToValidate="txtHotDealChildPrice"
                                                                                            runat="server" ResourceName="reqValHotDealChildPrice" Display="Dynamic" ErrorMessage="[Hot Deal Rate for Child - Please enter rate.]">
                                                                                        </actl:RequiredFieldValidator>
                                                                                    </td>
                                                                                    <%--<td class="Pad-L2" align="left">
                                                                                        <actl:CompareValidator ID="compValHotDealChildPrice" runat="server" ControlToValidate="txtHotDealChildPrice"
                                                                                            Display="Dynamic" ErrorMessage="[Hot Deal Rate for Child - Please enter numeric value.]"
                                                                                            Operator="DataTypeCheck" ResourceName="compValHotDealChildPrice" Type="Currency">
                                                                                        </actl:CompareValidator>
                                                                                    </td>--%>
                                                                                    <td class="Pad-L2">
                                                                                        <actl:CustomValidator ID="custValTxtHDChildPrice" ResourceName="compValHotDealChildPrice"
                                                                                            ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                            runat="server" ControlToValidate="txtHotDealChildPrice" ClientValidationFunction="custValRateTextBox"
                                                                                            ErrorMessage="[Hot Deal Rate for Child - Please enter numeric value.]" Display="Dynamic"> </actl:CustomValidator>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Pad-T10">
                                                                            <actl:Label ID="lblHotDealInfant" runat="server" CssClass="Label" ResourceName="lblPerInfant"
                                                                                Text="[Per Infant]">
                                                                            </actl:Label>
                                                                        </td>
                                                                        <td class="Pad-T10">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr>
                                                                                    <td class="Pad-L7" align="left">
                                                                                        <actl:TextBox ID="txtHotDealInfantPrice" SkinID="MandatoryTextBox" runat="server"
                                                                                            MaxLength="19" Text="0">
                                                                                        </actl:TextBox>
                                                                                    </td>
                                                                                    <td class="Pad-L5" align="left">
                                                                                        <actl:RequiredFieldValidator ID="reqValHotDealInfantPrice" ControlToValidate="txtHotDealInfantPrice"
                                                                                            runat="server" ResourceName="reqValHotDealInfantPrice" Display="Dynamic" ErrorMessage="[Hot Deal Rate for Infant - Please enter rate.]">
                                                                                        </actl:RequiredFieldValidator>
                                                                                    </td>
                                                                                    <%--<td class="Pad-L2" align="left">
                                                                                        <actl:CompareValidator ID="compValHotDealInfantPrice" runat="server" ControlToValidate="txtHotDealInfantPrice"
                                                                                            Display="Dynamic" ErrorMessage="[Hot Deal Rate for Infant - Please enter numeric value.]"
                                                                                            Operator="DataTypeCheck" ResourceName="compValHotDealInfantPrice" Type="Currency">
                                                                                        </actl:CompareValidator>
                                                                                    </td>--%>
                                                                                    <td class="Pad-L2">
                                                                                        <actl:CustomValidator ID="custValTxtHDInfantPrice" ResourceName="compValHotDealInfantPrice"
                                                                                            ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                            runat="server" ControlToValidate="txtHotDealInfantPrice" ClientValidationFunction="custValRateTextBox"
                                                                                            ErrorMessage="[Hot Deal Rate for Infant - Please enter numeric value.]" Display="Dynamic"> </actl:CustomValidator>
                                                                                    </td>
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
                                            <tr runat="server" id="trPerEquipmentHotDealRate" style="display: none">
                                                <td class="Pad-T10"></td>
                                                <td class="Pad-T10">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="Pad-L7" align="left" valign="top">
                                                                <actl:Label ID="lblHotDealRateEquip" SkinID="LabelBold" ResourceName="lblHotDealRate"
                                                                    runat="server" Text="[Rate]">
                                                                </actl:Label>
                                                            </td>
                                                            <td class="Pad-L20" align="left" valign="top">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td valign="top" align="left">
                                                                            <actl:Label ID="lblHotDealCategoryHeaderPerEquip" SkinID="LabelBold" ResourceName="lblCategory"
                                                                                runat="server" Text="[Category]">
                                                                            </actl:Label>
                                                                        </td>
                                                                        <td class="Pad-L7" valign="top" align="left">
                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                <tr>
                                                                                    <td align="left" valign="top">
                                                                                        <actl:Label ID="lblHotDealRateHeaderPerEquip" SkinID="LabelBold" runat="server" Text="[Price (in ##currencycode##)]">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <td align="left" class="Pad-L7" valign="top">
                                                                                        <actl:CustomValidator ID="custValHotDealRatePerEquip" runat="server" ValidateEmptyText="true"
                                                                                            ErrorMessage="[Hot Deal Rate for Equipment - Please enter price for atleast one category.]"
                                                                                            ResourceName="custValHotDealRatePerEquip" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                            ClientValidationFunction="fnCheckHotDealPerEquipmentRate" Display="Dynamic">
                                                                                        </actl:CustomValidator>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Pad-T10">
                                                                            <actl:Label ID="lblPerEquipment" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                ResourceName="lblPerEquipment" Text="[Per Equipment]">
                                                                            </actl:Label>
                                                                        </td>
                                                                        <td class="Pad-T10">
                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                <tr>
                                                                                    <td class="Pad-L7" align="left">
                                                                                        <actl:TextBox ID="txtHotDealPerEquipmentPrice" runat="server" MaxLength="19" SkinID="MandatoryTextBox"
                                                                                            Text="0">
                                                                                        </actl:TextBox>
                                                                                    </td>
                                                                                    <td class="Pad-L5" align="left">
                                                                                        <actl:RequiredFieldValidator ID="reqValHotDealPerEquip" ControlToValidate="txtHotDealPerEquipmentPrice"
                                                                                            runat="server" ResourceName="reqValHotDealPerEquip" Display="Dynamic" ErrorMessage="[Hot Deal Rate for Equipment - Please enter rate.]">
                                                                                        </actl:RequiredFieldValidator>
                                                                                    </td>
                                                                                    <%--<td class="Pad-L2" align="left">
                                                                                        <actl:CompareValidator ID="compValHotDealPerEquip" runat="server" ControlToValidate="txtHotDealPerEquipmentPrice"
                                                                                            Display="Dynamic" ErrorMessage="[Hot Deal Rate for Equipment - Please enter numeric value.]"
                                                                                            Operator="DataTypeCheck" ResourceName="compValHotDealPerEquip" Type="Currency">
                                                                                        </actl:CompareValidator>
                                                                                    </td>--%>
                                                                                    <td class="Pad-L2">
                                                                                        <actl:CustomValidator ID="custValHoteDealPerEquip" ResourceName="compValHotDealPerEquip"
                                                                                            ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                            runat="server" ControlToValidate="txtHotDealPerEquipmentPrice" ClientValidationFunction="custValRateTextBox"
                                                                                            ErrorMessage="[Hot Deal Rate for Equipment - Please enter numeric value.]" Display="Dynamic"> </actl:CustomValidator>
                                                                                    </td>
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
                                            <%if (allowManageInclusion == "1")
                                                { %>
                                            <tr>
                                                <td align="left" colspan="2" class="Pad-T10">
                                                    <actl:Label ID="lblDurationNote" runat="server" SkinID="ErrorLabel" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.ManagePackageInclusion"
                                                        ResourceName="lblDurationNote" Text="[Note:- Please note if you update package duration days then day wise itinerary details (Package Inclusions) will be update accordingly.]"></actl:Label>
                                                </td>
                                            </tr>
                                            <%} %>
                                            <tr>
                                                <td class="Pad-T10" align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <actl:Button ID="ibtnSave" runat="server" Text="[Save]" OnClick="ibtnSave_Click"
                                                                    OnClientClick="EmptyMessage()" />
                                                            </td>
                                                            <td class="Pad-L7">
                                                                <input type="reset" value="[Reset]" id="reset1" title="reset" class="Button" />
                                                            </td>
                                                            <td class="Pad-L7">
                                                                <actl:Button ID="ibtnCancelSave" Text="[Cancel]" CausesValidation="false" runat="server"
                                                                    OnClick="ibtnCancelSave_Click" />
                                                            </td>
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
                </table>
            </td>
        </tr>
        <!-- End for Configure Schedule -->
        <tr>
            <td class="Pad-T10">
                <table border="0" cellpadding="0" cellspacing="0" class="Web-Width">
                    <tr>
                        <td class="Page-Sub-Section-Title">
                            <actl:Label BusinessName="true" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                ResourceName="lblListofRates" ID="lblListofRates" runat="server" Text="[List of Schedules]">
                            </actl:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="Page-Section-Bg">
                            <table border="0" cellpadding="0" cellspacing="0" class="Web-Width Pad-8">
                                <!-- Grid View -->
                                <tr>
                                    <td>
                                        <asp:UpdateProgress ID="UpdateProgress1" AssociatedUpdatePanelID="uppnlRateGridView"
                                            runat="server">
                                            <ProgressTemplate>
                                                <table cellpadding="0" cellspacing="0" class="Web-Width" border="0">
                                                    <tr>
                                                        <td align="center">
                                                            <actl:Image ID="imgListingProgress" runat="server" SkinID="Progress" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:UpdatePanel ID="uppnlRateGridView" runat="server">
                                            <ContentTemplate>
                                                <actl:GridView ID="gvRates" ResourceName="gvRates" runat="server" AutoGenerateColumns="False"
                                                    AllowPaging="True" AllowSorting="True" DataKeyNames="NActivitySeasonScheduleID"
                                                    ShowFooter="false" EmptyDataText="[No record(s) found.]" OnRowCancelingEdit="gvRates_RowCancelingEdit"
                                                    OnRowDataBound="gvRates_RowDataBound" OnSelectedIndexChanging="gvRates_SelectedIndexChanging"
                                                    OnRowDeleting="gvRates_RowDeleting" OnRowCommand="gvRates_RowCommand" SkinID="DefaultGrid"
                                                    OnSorting="gvRates_Sorting" OnPageIndexChanging="gvRates_PageIndexIndexChanging">
                                                    <Columns>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td width="15%" align="center">
                                                                            <actl:Label ID="lblViewRateDetails" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                ResourceName="lblViewRateDetails" Text="[View Rate]"></actl:Label>
                                                                        </td>
                                                                        <td width="20%" align="left">
                                                                            <actl:LinkButton ID="lbtnScheduleNameHeader" runat="server" BusinessName="true" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                ResourceName="lbtnScheduleNameHeader" CausesValidation="false" CommandName="Sort"
                                                                                CommandArgument="cScheduleName" Text="[Schedule Name]"></actl:LinkButton>
                                                                        </td>
                                                                        <td width="10%" align="left">
                                                                            <actl:LinkButton ID="lbtnRateDateHeader" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                ResourceName="lbtnRateDateHeader" CausesValidation="false" CommandName="Sort"
                                                                                CommandArgument="FromDate" Text="[Date]"></actl:LinkButton>
                                                                        </td>
                                                                        <td width="10%" align="center">
                                                                            <actl:LinkButton ID="lbtnTimeHeader" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                ResourceName="lbtnTimeHeader" CausesValidation="false" CommandName="Sort" CommandArgument="NStartHour"
                                                                                Text="[Time]"></actl:LinkButton>
                                                                        </td>
                                                                        <td width="12%" align="center">
                                                                            <actl:LinkButton ID="lbtnMaxBookingHeader" runat="server" ResourceBaseName="ExcursionExtranetWeb.App_Controls.UserControls.BlackoutDates.gvActiviesScheduleList"
                                                                                ResourceName="lblHeadCapacity" CausesValidation="false" CommandName="Sort" CommandArgument="NMaxCapacity"
                                                                                Text="[Capacity]"></actl:LinkButton>
                                                                        </td>
                                                                        <td width="13%" align="center">
                                                                            <actl:Label ID="lblCutoffdaysHdr" runat="server" ResourceBaseName="HotelExtranetWeb.MemberAdmin.Allocation"
                                                                                ResourceName="lblCutoffDays" Text="[Cutoff days]"></actl:Label>
                                                                        </td>
                                                                        <td width="10%" align="center">
                                                                            <actl:Label ID="lblEditHeader" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                ResourceName="lblEditHeader" Text="[Edit]"></actl:Label>
                                                                        </td>
                                                                        <td width="10%" align="center">
                                                                            <actl:Label ID="lblDeleteHeader" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                ResourceName="lblDeleteHeader" Text="[Delete]"></actl:Label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td width="15%" align="center">
                                                                            <actl:ImageButton ID="ibtnViewRate" runat="server" CausesValidation="false" ResourceName="ibtnViewRate"
                                                                                AlternateText="[Click here to Show Rate Details]" SkinID="Spacer" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule.gvRates"
                                                                                CommandName="Select" CommandArgument='<%#  Eval("nActivitySeasonScheduleID")   %>' />
                                                                            <actl:HiddenField ID="hfScheduleID" runat="server" Value='<%#  Eval("nActivitySeasonScheduleID")   %>' />
                                                                        </td>
                                                                        <td width="20%" align="left">
                                                                            <actl:Label ID="lblSchName" runat="server" ToolTip='<%# Eval("CScheduleName") %>'
                                                                                Text='<%# Convert.ToString(Eval("CScheduleName")).Length > 23 ? Eval("CScheduleName").ToString().Substring(0,22) + "..."  : Convert.ToString(Eval("CScheduleName")) %>'></actl:Label>
                                                                            <%--Text = '<%# Eval("CScheduleName").ToString().Length > 23 ? Eval("CScheduleName").ToString().Substring(0,22) + "..."  : Eval("CScheduleName") %>'></actl:Label>--%>
                                                                        </td>
                                                                        <td width="10%" align="left">
                                                                            <actl:Label ID="lblRateDate" runat="server" Text='<%# Convert.ToDateTime(Eval("FromDate")).ToShortDateString() %>'></actl:Label>
                                                                        </td>
                                                                        <td width="10%" align="center">
                                                                            <actl:Label ID="lblTime" runat="server" Text='<%# Convert.ToString(Eval("NStartHour")).PadLeft(2,padChar)  + ":" + Convert.ToString(Eval("NStartMinute")).PadLeft(2,padChar)  %>'></actl:Label>
                                                                        </td>
                                                                        <td width="12%" align="center">
                                                                            <actl:Label ID="lbtnMaxBooking" runat="server" Text='<%# Eval("NMaxCapacity") %>'></actl:Label>
                                                                        </td>
                                                                        <td width="13%" align="center">
                                                                            <actl:Label ID="lblCutoffdays" runat="server" Text='<%# Eval("CutoffDays") %>'></actl:Label>
                                                                        </td>
                                                                        <td width="10%" align="center">
                                                                            <actl:Button ID="ibtnEdit" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule.gvRates"
                                                                                ToolTip="[Edit]" ResourceName="ibtnEdit" SkinID="GridEditButton" CommandArgument='<%#  Eval("nActivitySeasonScheduleID")   %>'
                                                                                CommandName="Editing" CausesValidation="false"></actl:Button>
                                                                        </td>
                                                                        <td width="10%" align="center">
                                                                            <actl:Button ID="ibtnDelete" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule.gvRates"
                                                                                ResourceName="ibtnDelete" CommandArgument="Del" CommandName="Delete" ToolTip="[Delete]"
                                                                                SkinID="GridDeleteButton" CausesValidation="false"></actl:Button>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td></td>
                                                                        <td colspan="5">
                                                                            <AJX:CollapsiblePanelExtender ID="cpeRateDetails" runat="Server" TargetControlID="pnlRateDetails"
                                                                                ExpandControlID="ibtnViewRate" CollapseControlID="ibtnViewRate" ScrollContents="False"
                                                                                ImageControlID="ibtnViewRate" SkinID="CollapsiblePanel" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td></td>
                                                                        <td colspan="5">
                                                                            <actl:Panel ID="pnlRateDetails" runat="server" ScrollBars="None" CssClass="Pad-T5">
                                                                                <actl:GridView ID="gvRateDetails" SkinID="DefaultGrid" Visible="false" ResourceName="gvRateDetails"
                                                                                    runat="server" AutoGenerateColumns="False" DataKeyNames="NActivitySeasonScheduleID"
                                                                                    ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule.gvRates.gvRateDetails"
                                                                                    ShowFooter="false" EmptyDataText="[No record(s) found.]" OnRowDataBound="gvRateDetails_RowDataBound">
                                                                                    <Columns>
                                                                                        <asp:TemplateField>
                                                                                            <HeaderTemplate>
                                                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                                    <tr>
                                                                                                        <td width="25%" align="left" class="Pad-L10">
                                                                                                            <actl:Label ID="lblUnitDescriptionHeader" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule.gvRates.gvRateDetails"
                                                                                                                ResourceName="lblUnitDescriptionHeader" Text="[Unit Description]"></actl:Label>
                                                                                                        </td>
                                                                                                        <td width="25%" align="center">
                                                                                                            <actl:Label ID="lblUnitPriceHeader" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule.gvRates.gvRateDetails"
                                                                                                                ResourceName="lblUnitPriceHeader" CausesValidation="false" Text="[Price]"></actl:Label>
                                                                                                        </td>
                                                                                                        <td width="25%" align="center">
                                                                                                            <actl:Label ID="lblUnitMinQtyHeader" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule.gvRates.gvRateDetails"
                                                                                                                ResourceName="lblUnitMinQtyHeader" CausesValidation="false" Text="[Minimum Quantity]"></actl:Label>
                                                                                                        </td>
                                                                                                        <td width="25%" align="center">
                                                                                                            <actl:Label ID="lblUnitMaxQtyHeader" runat="server" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule.gvRates.gvRateDetails"
                                                                                                                ResourceName="lblUnitMaxQtyHeader" CausesValidation="false" Text="[Maximum Quantity]"></actl:Label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </HeaderTemplate>
                                                                                            <ItemTemplate>
                                                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                                    <tr>
                                                                                                        <td width="25%" align="left" class="Pad-L10">
                                                                                                            <actl:Label ID="lblUnitDescription" runat="server" Text='<%# Eval("CUnitDescription") %>'></actl:Label>
                                                                                                        </td>
                                                                                                        <td width="25%" align="center">
                                                                                                            <actl:Label ID="lblUnitPrice" runat="server" Text='<%# fnApplyThousandOperator(Eval("Nrate").ToString()) %>'></actl:Label>
                                                                                                        </td>
                                                                                                        <td width="25%" align="center">
                                                                                                            <actl:Label ID="lblUnitMinQty" runat="server" Text='<%# Eval("MinQuantity") %>'></actl:Label>
                                                                                                        </td>
                                                                                                        <td width="25%" align="center">
                                                                                                            <actl:Label ID="lblUnitMaxQty" runat="server" Text='<%# Eval("MaxQuantity") %>'></actl:Label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </ItemTemplate>
                                                                                        </asp:TemplateField>
                                                                                    </Columns>
                                                                                </actl:GridView>
                                                                            </actl:Panel>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </actl:GridView>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <!-- End Grid -->
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <!-- For Configre Schedule -->
        <tr>
            <td runat="server" id="tdConfigureSchedule" class="Pad-T10">
                <table cellpadding="0" cellspacing="0" border="0" class="Web-Width">
                    <tr>
                        <td class="Page-Sub-Section-Title">
                            <actl:Label ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                ResourceName="lblRateSetupHeader" ID="lblRateSetupHeader" runat="server" Text="[Configure Rates]">
                            </actl:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="Page-Section-Bg" valign="top">
                            <table cellpadding="0" cellspacing="0" border="0" class="Web-Width Pad-8">
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0" class="Web-Width">
                                            <tr>
                                                <td valign="top">
                                                    <!--list table starts here-->
                                                    <asp:UpdateProgress ID="UpdateProgressExcuType" AssociatedUpdatePanelID="panelExcursionType"
                                                        runat="server">
                                                        <ProgressTemplate>
                                                            <table cellpadding="0" cellspacing="0" class="Web-Width" border="0">
                                                                <tr>
                                                                    <td align="center">
                                                                        <actl:Image ID="imgRateProgress" runat="server" SkinID="Progress" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>
                                                    <asp:UpdatePanel ID="panelExcursionType" runat="server">
                                                        <ContentTemplate>
                                                            <table cellspacing="0" border="0" cellpadding="0" class="Web-Width">
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <actl:Label ID="lblMsg" runat="server" SkinID="SuccessLabel"></actl:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <actl:ValidationSummary ID="valSummaryRateSetup" ValidationGroup="RateSetup" runat="server"
                                                                            DisplayMode="BulletList" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <actl:ValidationSummary ID="valSumEditRates" ValidationGroup="EditRates" runat="server"
                                                                            DisplayMode="BulletList" />
                                                                    </td>
                                                                </tr>
                                                                <tr visible="false" runat="server" id="trEmptyDateHeader">
                                                                    <td>
                                                                        <actl:Label ID="lblStartTimeEquipment" runat="server" Text="[Start Time]" ResourceName="lbtnStartTime"
                                                                            SkinID="LabelBold" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule.gvRates"></actl:Label>
                                                                    </td>
                                                                    <td class="Pad-L7">
                                                                        <actl:Label ID="lblNoOfEquipment" runat="server" Text="[Available Quantity Of Equipment]"
                                                                            SkinID="LabelBold" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule.gvRates"></actl:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <actl:Label ID="lblScheduleName" SkinID="LabelBold" runat="server" Text="[Schedule Name]"
                                                                            BusinessName="true" ResourceName="lblScheduleName" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"></actl:Label>
                                                                    </td>
                                                                    <td class="Pad-L7">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td align="left">
                                                                                    <actl:TextBox ID="txtScheduleName" SkinID="MandatoryTextBox" runat="server" Width="250px"
                                                                                        MaxLength="200">
                                                                                    </actl:TextBox>
                                                                                </td>
                                                                                <td class="Pad-L5" align="left">
                                                                                    <actl:RequiredFieldValidator ID="reqValScheduleName" runat="server" ControlToValidate="txtScheduleName"
                                                                                        Display="Dynamic" BusinessName="true" ResourceName="reqValScheduleName" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                        ValidationGroup="RateSetup" ErrorMessage="[Please enter Schedule name.]">
                                                                                    </actl:RequiredFieldValidator>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="22%" class="Pad-T10">
                                                                        <actl:Label ID="lblRateFromDate" SkinID="LabelBold" runat="server" Text="[Date]"
                                                                            ResourceName="lblRateFromDate"></actl:Label>
                                                                    </td>
                                                                    <td align="left" class="Pad-T10 Pad-L7">
                                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td>
                                                                                    <actl:TextBox ID="txtRateDateFrom" runat="server" CausesValidation="false" Enabled="true" />
                                                                                    <actl:HiddenField ID="hfServerDateInUsFormat" runat="server" />
                                                                                </td>
                                                                                <td class="Pad-L7" align="left">
                                                                                    <actl:ImageButton ID="ibtnRateFromDate" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                        ResourceName="ibtnRateFromDate" SkinID="Calender" CausesValidation="false" runat="server"></actl:ImageButton>
                                                                                </td>
                                                                                <td class="Pad-L2" valign="top" align="left">
                                                                                    <actl:CompareValidator ID="compValRateDateFrom" ValidationGroup="RateSetup" SetFocusOnError="true"
                                                                                        runat="server" ErrorMessage="[Date - Enter Valid Date]" ControlToValidate="txtRateDateFrom"
                                                                                        Operator="DataTypeCheck" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                        Type="Date" ResourceName="compValRateDateFrom"></actl:CompareValidator>
                                                                                    <actl:CustomValidator ID="custValRatePastDate" runat="server" BusinessName="true"
                                                                                        ResourceName="custValRatePastDate" ControlToValidate="txtRateDateFrom" Display="Dynamic"
                                                                                        ValidationGroup="RateSetup" ErrorMessage="[Please Select Date between Schedule's Date Range]"
                                                                                        OnServerValidate="custValRatePastDate_ServerValidate" SetFocusOnError="True"
                                                                                        ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule">
                                                                                    </actl:CustomValidator>
                                                                                    <%--ClientValidationFunction="fnCheckRateDate"--%>
                                                                                    <AJX:CalendarExtender ID="calFromDateRangeDatePicker" OnClientShowing="SetTodaysDate"
                                                                                        TargetControlID="txtRateDateFrom" PopupButtonID="ibtnRateFromDate" PopupPosition="BottomLeft"
                                                                                        runat="server">
                                                                                    </AJX:CalendarExtender>
                                                                                </td>
                                                                                <td id="tdToDate" class="Pad-L20" visible="false" runat="server">
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td align="left">
                                                                                                <actl:Label ID="lblRateToDate" SkinID="LabelBold" runat="server" Text="[To Date]"
                                                                                                    ResourceName="lblRateFromDate" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"></actl:Label>
                                                                                            </td>
                                                                                            <td class="Pad-L7" align="left">
                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <actl:TextBox ID="txtRateToDate" runat="server" CausesValidation="false" Enabled="true" />
                                                                                                        </td>
                                                                                                        <td class="Pad-L7">
                                                                                                            <actl:ImageButton ID="ibtnRateTodate" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                                                ResourceName="ibtnRateTodate" SkinID="Calender" CausesValidation="false" runat="server"></actl:ImageButton>
                                                                                                        </td>
                                                                                                        <td class="Pad-L2" align="left">
                                                                                                            <actl:RequiredFieldValidator ID="reqValRateToDate" ValidationGroup="RateSetup" ControlToValidate="txtRateToDate"
                                                                                                                ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                                                ResourceName="reqValRateToDate" Display="Dynamic" ErrorMessage="[Please choose to date]"
                                                                                                                runat="server" SetFocusOnError="True">
                                                                                                            </actl:RequiredFieldValidator>
                                                                                                            <actl:CustomValidator ID="custValRateToDate" runat="server" BusinessName="true" ResourceName="custValRateToDate"
                                                                                                                Display="Dynamic" ValidationGroup="RateSetup" SetFocusOnError="True" ErrorMessage="[Please Select To Date between Schedule's Date Range and less than from date]"
                                                                                                                ClientValidationFunction="fnCheckRateFromToDate" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule">
                                                                                                            </actl:CustomValidator>
                                                                                                            <AJX:CalendarExtender ID="calExtenderToDate" OnClientShowing="SetTodaysDate" TargetControlID="txtRateToDate"
                                                                                                                PopupButtonID="ibtnRateTodate" PopupPosition="BottomLeft" runat="server">
                                                                                                            </AJX:CalendarExtender>
                                                                                                        </td>
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
                                                                    <td class="Pad-T10">
                                                                        <actl:Label ID="lblStartTime" runat="server" Text="[Start Time]" SkinID="LabelBold"
                                                                            ResourceName="lblStartTime" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"></actl:Label>
                                                                    </td>
                                                                    <td class="Pad-T10 Pad-L7">
                                                                        <table cellspacing="0" cellpadding="0" border="0">
                                                                            <tr>
                                                                                <td align="left">
                                                                                    <actl:DropDownList ID="ddlHour" runat="server" AppendDataBoundItems="true">
                                                                                        <asp:ListItem Value="0">HH</asp:ListItem>
                                                                                    </actl:DropDownList>
                                                                                </td>
                                                                                <td class="Pad-L5" align="left">
                                                                                    <actl:DropDownList ID="ddlMinute" runat="server" AppendDataBoundItems="true">
                                                                                        <asp:ListItem Value="0">MM</asp:ListItem>
                                                                                    </actl:DropDownList>
                                                                                </td>
                                                                                <td class="Pad-L2" align="left">
                                                                                    <actl:CustomValidator ID="custValTime" ValidationGroup="RateSetup" ResourceName="custValTime"
                                                                                        runat="server" ErrorMessage="[Please select Start Time.]" ClientValidationFunction="SelectStartTime"
                                                                                        ValidateEmptyText="true" OnServerValidate="custValTime_ServerValidate">
                                                                                    </actl:CustomValidator>
                                                                                </td>
                                                                                <td align="left" class="Pad-L2">
                                                                                    <actl:CustomValidator ID="custValTimeOverlap" ValidationGroup="RateSetup" runat="server"
                                                                                        ResourceName="custValTimeOverlap" ErrorMessage="[Duplicate time slot found. Please enter another time slot.]"
                                                                                        OnServerValidate="custValTimeOverlap_ServerValidate">
                                                                                    </actl:CustomValidator>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="Pad-T10">
                                                                        <actl:Label ID="lblMaximumBookingAllowed" SkinID="LabelBold" runat="server" Text="[Capacity]"
                                                                            ResourceName="lblHeadCapacity" ResourceBaseName="ExcursionExtranetWeb.App_Controls.UserControls.BlackoutDates.gvActiviesScheduleList"></actl:Label>
                                                                    </td>
                                                                    <td class="Pad-T10 Pad-L7">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td align="left">
                                                                                    <AJX:TextBoxWatermarkExtender ID="txtAjaxExt" runat="server" WatermarkText="[Click here to Add new]"
                                                                                        TargetControlID="txtInsertQuantity" />
                                                                                    <actl:TextBox ID="txtInsertQuantity" SkinID="MandatoryTextBox" runat="server" Width="150px"
                                                                                        MaxLength="3">
                                                                                    </actl:TextBox>
                                                                                </td>
                                                                                <td class="Pad-L5" align="left">
                                                                                    <actl:RequiredFieldValidator ID="reqValInsertQuantity" runat="server" ControlToValidate="txtInsertQuantity"
                                                                                        Display="Dynamic" ResourceName="reqValInsertQuantity" ValidationGroup="RateSetup">
                                                                                    </actl:RequiredFieldValidator>
                                                                                    <actl:RegularExpressionValidator ResourceName="regExpValInsertQuantity" ID="regExpValInsertQuantity"
                                                                                        runat="server" ValidationGroup="RateSetup" ControlToValidate="txtInsertQuantity"
                                                                                        Display="Dynamic" ValidationExpression="([0-9])*">
                                                                                    </actl:RegularExpressionValidator>
                                                                                </td>
                                                                                <td class="Pad-L2" align="left">
                                                                                    <actl:CustomValidator ID="custValMaxCapacity" runat="server" Display="Dynamic" ErrorMessage="[Maximum booking allowed per schedule can not be less than total booking.]"
                                                                                        OnServerValidate="custValMaxCapacity_ServerValidate" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                        ResourceName="custValMaxCapacity" ValidationGroup="RateSetup"></actl:CustomValidator>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="Pad-T10">
                                                                        <actl:Label ID="lblCutOffDays" ResourceBaseName="HotelExtranetWeb.MemberAdmin.Allocation"
                                                                            SkinID="LabelBold" ResourceName="lblCutOffDays" Text="[Cut off days]" runat="server"> </actl:Label>
                                                                    </td>
                                                                    <td class="Pad-T10 Pad-L7">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td>
                                                                                    <actl:TextBox MaxLength="3" Width="75px" ID="txtCutOffDays" SkinID="MandatoryTextBox"
                                                                                        Style="text-align: right;" runat="server" Text="0" />
                                                                                </td>
                                                                                <td class="Pad-L5">
                                                                                    <actl:RequiredFieldValidator ID="reqValCutOffDays" runat="server" ResourceName="RequiredCutOffDays"
                                                                                        ResourceBaseName="ExtranetCommon" runat="server" ControlToValidate="txtCutOffDays"
                                                                                        ErrorMessage="[Please enter cutoff days.]" Display="Dynamic" ValidationGroup="RateSetup"></actl:RequiredFieldValidator>
                                                                                </td>
                                                                                <td class="Pad-L2">
                                                                                    <actl:RegularExpressionValidator ID="regexValCutOffDays" ResourceName="regexValCutOffDays"
                                                                                        ResourceBaseName="HotelExtranetWeb.MemberAdmin.Allocation" runat="server" ControlToValidate="txtCutOffDays"
                                                                                        ErrorMessage="[Cutoff Days - Please enter only numeric values.]" ValidationExpression="([0-9])*"
                                                                                        Display="Dynamic" ValidationGroup="RateSetup"></actl:RegularExpressionValidator>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="Pad-T10">
                                                                        <actl:Label ID="lblShowUnavailable" runat="server" ResourceName="lblShowUnavailable"
                                                                            Text="[Show if Unavailable]" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursion"
                                                                            SkinID="LabelBold">
                                                                        </actl:Label>
                                                                    </td>
                                                                    <td class="Pad-T10 Pad-L7">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td align="left" colspan="3">
                                                                                    <actl:CheckBox ID="chkShowUnavailable" Checked="false" runat="server" SkinID="CheckBoxBold" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <div id="divEquipment" runat="server">
                                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                                <tr>
                                                                                    <td class="Pad-T10">
                                                                                        <actl:Label ID="lblEquipmentCategory" SkinID="LabelBold" runat="server" ResourceName="lblCategory"
                                                                                            Text="[Category]">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <!-- hide below td by jignesh as per suggession by dhimant bhai because comment is not used any where -->
                                                                                    <td class="Pad-T10 Pad-L7" style="display: none">
                                                                                        <actl:Label ID="lblEquipmentComment" SkinID="LabelBold" runat="server" ResourceName="lblComment"
                                                                                            Text="[Comment]">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                            <tr>
                                                                                                <td class="Pad-T10 Pad-L20">
                                                                                                    <actl:Label ID="lblPrice" SkinID="LabelBold" runat="server" Text="[Price (in ##currencycode##)]">
                                                                                                    </actl:Label>
                                                                                                </td>
                                                                                                <td class="Pad-L5 Pad-T10">
                                                                                                    <actl:CustomValidator ID="custValEquipmentPrice" runat="server" ValidateEmptyText="true"
                                                                                                        ErrorMessage="[Please enter price for atleast one category.]" ValidationGroup="RateSetup"
                                                                                                        ResourceName="custValEquipmentPrice" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                                        OnServerValidate="custValRateDetails_ServerValidate" Display="Dynamic" ClientValidationFunction="fnCheckRateEquipmentRate">
                                                                                                    </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-T10 Pad-L10">
                                                                                        <actl:Label ID="lblEquipMinQty" SkinID="LabelBold" runat="server" ResourceName="lblMinQty"
                                                                                            Text="[Minimum Quantity]">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <td class="Pad-T10 Pad-L10">
                                                                                        <actl:Label ID="lblEquipMaxQty" runat="server" SkinID="LabelBold" ResourceName="lblMaxQty"
                                                                                            Text="[Maximum Quantity]">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="Pad-T10">
                                                                                        <actl:Label ID="lblEquipmentType" SkinID="NormalLabel" runat="server" ResourceName="lblEquipmentType"
                                                                                            Text="[Per Equipment]">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <!-- hide below td by jignesh as per suggession by dhimant bhai because comment is not used any where -->
                                                                                    <td class="Pad-L7 Pad-T10" style="display: none">
                                                                                        <actl:TextBox ID="txtEquipmentComments" runat="server" MaxLength="200">
                                                                                        </actl:TextBox>
                                                                                    </td>
                                                                                    <td class="Pad-L20 Pad-T10">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtPrice" SkinID="MandatoryTextBox" runat="server" MaxLength="19"
                                                                                                        Text="0" Width="100px">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValPrice" Display="Dynamic" ResourceName="reqValPrice"
                                                                                                        runat="server" ControlToValidate="txtPrice" ErrorMessage="[Please enter Price].">
                                                                                                    </actl:RequiredFieldValidator>
                                                                                                </td>
                                                                                                <%--<td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValEquipmentPrice" runat="server" ControlToValidate="txtPrice"
                                                                                                        Display="Dynamic" ErrorMessage="[Price for Equipment - Please enter numeric only.]"
                                                                                                        Operator="DataTypeCheck" ResourceName="regExpValPrice" Type="Currency">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>--%>
                                                                                                <td class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="regexCustValEquipmentPrice" ResourceName="regExpValPrice"
                                                                                                        ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                                        runat="server" ControlToValidate="txtPrice" ClientValidationFunction="custValRateTextBox"
                                                                                                        ErrorMessage="[Price for Equipment - Please enter numeric only.]" Display="Dynamic"> </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtEquipmentMinQty" Width="100px" SkinID="MandatoryTextBox" runat="server"
                                                                                                        MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqEquipmentMinQty" ValidationGroup="RateSetup"
                                                                                                        Display="Dynamic" ErrorMessage="[Minimum Quantity for Equipment - Please enter Quantity.]"
                                                                                                        runat="server" ControlToValidate="txtEquipmentMinQty" ResourceName="reqEquipmentMinQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValEquipmentMinQty" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtEquipmentMinQty" Display="Dynamic" ErrorMessage="[Minimum Quantity for Equipment - Please enter numeric data.]"
                                                                                                        Operator="DataTypeCheck" ResourceName="compValEquipmentMinQty" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtEquipmentMaxQty" Width="100px" SkinID="MandatoryTextBox" runat="server"
                                                                                                        MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValMaxQtyEquipment" ValidationGroup="RateSetup"
                                                                                                        Display="Dynamic" ErrorMessage="[Maximum Quantity for Equipment - Please enter Quantity.]"
                                                                                                        runat="server" ControlToValidate="txtEquipmentMaxQty" ResourceName="reqValMaxQtyEquipment" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValMaxQtyEquipment" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtEquipmentMaxQty" Display="Dynamic" ErrorMessage="[Maximum Quantity for Equipment - Please enter numeric data.]"
                                                                                                        Operator="DataTypeCheck" ResourceName="compValMaxQtyEquipment" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValQtyEquipment" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtEquipmentMaxQty" ControlToCompare="txtEquipmentMinQty"
                                                                                                        Display="Dynamic" ErrorMessage="[Maximum Quantity for Equipment - Maximum Quantity can not less than Minimum Quantity.]"
                                                                                                        Operator="GreaterThanEqual" ResourceName="compValAdultMinMaxQty" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValQtyEquipemnt" runat="server" ResourceName="custValQtyEquipemnt"
                                                                                                        Display="Dynamic" ValidationGroup="RateSetup" ErrorMessage="[Maximum Quantity for Equipment - Please Enter Maximum Quantity Greater than 0.]"
                                                                                                        ClientValidationFunction="fnCheckMaxEquipmentQuantity" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule">
                                                                                                    </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <div id="divPerson" runat="server">
                                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                                <tr>
                                                                                    <td class="Pad-T10">
                                                                                        <actl:Label ID="lblCategory" SkinID="LabelBold" runat="server" ResourceName="lblCategory"
                                                                                            Text="[Category]">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <!-- hide below td by jignesh as per suggession by dhimant bhai because comment is not used any where -->
                                                                                    <td class="Pad-T10 Pad-L10" style="display: none">
                                                                                        <actl:Label ID="lblComment" SkinID="LabelBold" runat="server" ResourceName="lblComment"
                                                                                            Text="[Comment]">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <table cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td class="Pad-T10 Pad-L20 ">
                                                                                                    <actl:Label ID="lblPersonPrice" SkinID="LabelBold" runat="server" Text="[Price (in ##currencycode##)]">
                                                                                                    </actl:Label>
                                                                                                </td>
                                                                                                <td class="Pad-L7 Pad-T10">
                                                                                                    <actl:CustomValidator ID="custValRateDetails" runat="server" ValidateEmptyText="true"
                                                                                                        ErrorMessage="[Please enter price for atleast one category.]" ValidationGroup="RateSetup"
                                                                                                        ResourceName="custValRateDetails" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                                        OnServerValidate="custValRateDetails_ServerValidate" Display="Dynamic" ClientValidationFunction="fnCheckRatePersonRate">
                                                                                                    </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-T10 Pad-L10" style="display: none">
                                                                                        <actl:Label ID="lblMinQty" runat="server" SkinID="LabelBold" ResourceName="lblMinQty"
                                                                                            Text="[Minimum Quantity]">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <td class="Pad-T10 Pad-L10" style="display: none">
                                                                                        <actl:Label ID="lblMaxQty" runat="server" SkinID="LabelBold" ResourceName="lblMaxQty"
                                                                                            Text="[Maximum Quantity]">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="Pad-T10">
                                                                                        <actl:Label ID="lblAdult" SkinID="NormalLabel" runat="server"
                                                                                            Text="Package Price (Per Adult - Twin Sharing)">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <!-- hide below td by jignesh as per suggession by dhimant bhai because comment is not used any where -->
                                                                                    <td class="Pad-L7" style="display: none">
                                                                                        <actl:TextBox ID="txtAdultComment" runat="server" MaxLength="200">
                                                                                        </actl:TextBox>
                                                                                    </td>
                                                                                    <td class="Pad-L20">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtAdultPrice" Width="130px" SkinID="MandatoryTextBox" runat="server"
                                                                                                        MaxLength="19" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValAdultPrice" ValidationGroup="RateSetup" ControlToValidate="txtAdultPrice"
                                                                                                        runat="server" ResourceName="reqValAdultPrice" Display="Dynamic" ErrorMessage="[Please enter Price for Twin Sharing).]">
                                                                                                    </actl:RequiredFieldValidator>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:CompareValidator ID="compValAdultPrice" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtAdultPrice" Display="Dynamic" ErrorMessage="[Price for Twin Sharing) - Please Enter Greater than 0.]"
                                                                                                        Operator="GreaterThan"  Type="Double">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                                <td class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValCFRatesAdultPrice" ResourceName="regExpAdultPrice"
                                                                                                        ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                                        ValidationGroup="RateSetup" runat="server" ControlToValidate="txtAdultPrice"
                                                                                                        ClientValidationFunction="custValRateTextBox" ErrorMessage="[Price for Twin Sharing) - Please enter numeric value.]"
                                                                                                        Display="Dynamic"> </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtAdultsMinQty" SkinID="MandatoryTextBox" Width="130px" runat="server"
                                                                                                        MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValAdultsMinQty" ValidationGroup="RateSetup"
                                                                                                        Display="Dynamic" ErrorMessage="[Minimum Quantity for Adults - Please enter Quantity.]"
                                                                                                        runat="server" ControlToValidate="txtAdultsMinQty" ResourceName="reqValAdultsMinQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValAdultMinQty" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtAdultsMinQty" Display="Dynamic" ErrorMessage="[Minimum Quantity for Adults - Please enter numeric data.]"
                                                                                                        Operator="DataTypeCheck" ResourceName="compValAdultMinQty" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtAdultMaxQty" SkinID="MandatoryTextBox" Width="130px" runat="server"
                                                                                                        MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValAdultsMaxQty" ValidationGroup="RateSetup"
                                                                                                        Display="Dynamic" ErrorMessage="[Maximum Quantity for Adults - Please enter Quantity.]"
                                                                                                        runat="server" ControlToValidate="txtAdultMaxQty" ResourceName="reqValAdultsMaxQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValAdultsMaxQty" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtAdultMaxQty" Display="Dynamic" ErrorMessage="[Maximum Quantity for Adults - Please enter numeric data.]"
                                                                                                        Operator="DataTypeCheck" ResourceName="compValAdultsMaxQty" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                                <td align="left">
                                                                                                    <actl:CompareValidator ID="compValAdultMinMaxQty" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtAdultMaxQty" ControlToCompare="txtAdultsMinQty" Display="Dynamic"
                                                                                                        ErrorMessage="[Maximum Quantity for Adults - Maximum Quantity can not less than Minimum Quantity.]"
                                                                                                        Operator="GreaterThanEqual" ResourceName="compValAdultMinMaxQty" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                                <td align="left">
                                                                                                    <actl:CustomValidator ID="custValAdultMaxQty" runat="server" ResourceName="custValAdultMaxQty"
                                                                                                        Display="Dynamic" ValidationGroup="RateSetup" ErrorMessage="[Maximum Quantity for Adults - Please Enter Maximum Quantity Greater than 0.]"
                                                                                                        ClientValidationFunction="fnCheckMaxAdultsQuantity" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule">
                                                                                                    </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="Pad-T10">
                                                                                        <actl:Label ID="lblChild" runat="server" CssClass="Label"
                                                                                            Text="Package Price (Per Child With Bed)">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <!-- hide below td by jignesh as per suggession by dhimant bhai because comment is not used any where -->
                                                                                    <td class="Pad-T10 Pad-L7" style="display: none">
                                                                                        <actl:TextBox ID="txtChildComment" runat="server" MaxLength="200">
                                                                                        </actl:TextBox>
                                                                                    </td>
                                                                                    <td class="Pad-L20 Pad-T10">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtChildPrice" SkinID="MandatoryTextBox" Width="130px" runat="server"
                                                                                                        MaxLength="19" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValChildPrice" ValidationGroup="RateSetup" Display="Dynamic"
                                                                                                        ErrorMessage="[Please enter Price for Child.]" runat="server" ControlToValidate="txtChildPrice"
                                                                                                        ResourceName="reqValChildPrice" />
                                                                                                </td>
                                                                                                <%--<td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValChildPrice" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtChildPrice" Display="Dynamic" ErrorMessage="[Price for Child - Please enter valid data.]"
                                                                                                        Operator="DataTypeCheck" ResourceName="regExpChildPrice" Type="Currency">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>--%>
                                                                                                <td class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValCFRatesChildPrice" ResourceName="regExpChildPrice"
                                                                                                        ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                                        ValidationGroup="RateSetup" runat="server" ControlToValidate="txtChildPrice"
                                                                                                        ClientValidationFunction="custValRateTextBox" ErrorMessage="[Price for Child - Please enter valid data.]"
                                                                                                        Display="Dynamic"> </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtChildMinQty" SkinID="MandatoryTextBox" Width="130px" runat="server"
                                                                                                        MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValChildMinQty" ValidationGroup="RateSetup" Display="Dynamic"
                                                                                                        ErrorMessage="[Minimum Quantity for Child - Please enter Quantity.]" runat="server"
                                                                                                        ControlToValidate="txtChildMinQty" ResourceName="reqValChildMinQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValChildMinQty" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtChildMinQty" Display="Dynamic" ErrorMessage="[Minimum Quantity for Child - Please enter numeric data.]"
                                                                                                        Operator="DataTypeCheck" ResourceName="compValChildMinQty" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtChildMaxQty" SkinID="MandatoryTextBox" Width="130px" runat="server"
                                                                                                        MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValChildMaxQty" ValidationGroup="RateSetup" Display="Dynamic"
                                                                                                        ErrorMessage="[Maximum Quantity for Child - Please enter Quantity.]" runat="server"
                                                                                                        ControlToValidate="txtChildMaxQty" ResourceName="reqValChildMaxQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValChildMaxQty" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtChildMaxQty" Display="Dynamic" ErrorMessage="[Maximum Quantity for Child - Please enter numeric data.]"
                                                                                                        Operator="DataTypeCheck" ResourceName="compValChildMaxQty" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValChildMaxQty" runat="server" ResourceName="custValChildMaxQty"
                                                                                                        Display="Dynamic" ValidationGroup="RateSetup" ErrorMessage="[Maximum Quantity for Child - Please Enter Maximum Quantity Greater than 0.]"
                                                                                                        ClientValidationFunction="fnCheckMaxChildQuantity" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule">
                                                                                                    </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="Pad-T10">
                                                                                        <actl:Label ID="lblChildWithOutBed" runat="server" CssClass="Label" Text="Package Price (Per Child Without Bed)">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <td class="Pad-T10 Pad-L7" style="display: none">
                                                                                        <actl:TextBox ID="txtChildWithOutBedComment" runat="server" MaxLength="200">
                                                                                        </actl:TextBox>
                                                                                    </td>
                                                                                    <td class="Pad-L20 Pad-T10">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtChildWithOutBed" SkinID="MandatoryTextBox" Width="130px" runat="server" MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValChildWithOutBed" ResourceName="reqValChildWithOutBed" ValidationGroup="RateSetup" Display="Dynamic" ErrorMessage="Please enter Child Without Bed Price."
                                                                                                        runat="server" ControlToValidate="txtChildWithOutBed" />
                                                                                                </td>
                                                                                                <td class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValCFRatesChildWithOutBed" ResourceName="custValCFRatesChildWithOutBed" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtChildWithOutBed" ClientValidationFunction="custValRateTextBox"
                                                                                                        ErrorMessage="[Price for Child Without Bed - Please enter valid data.]" Display="Dynamic"> </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtChildWithOutBedMinQty" SkinID="MandatoryTextBox" Width="130px" runat="server" MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="RequiredFieldValidator3" ResourceName="RequiredFieldValidator3" ValidationGroup="RateSetup"
                                                                                                        Display="Dynamic"
                                                                                                        ErrorMessage="[Minimum Quantity for Child Without Bed - Please enter Quantity.]" runat="server" ControlToValidate="txtChildWithOutBedMinQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValChildWithOutBedMinQty" ResourceName="compValChildWithOutBedMinQty" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtChildWithOutBedMinQty" Display="Dynamic"
                                                                                                        ErrorMessage="[Minimum Quantity for Child Without Bed - Please enter numeric data.]"
                                                                                                        Operator="DataTypeCheck" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtChildWithOutBedMaxQty" SkinID="MandatoryTextBox" Width="130px" runat="server" MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" valign="top" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValChildWithOutBedMaxQty" ResourceName="reqValChildWithOutBedMaxQty" ValidationGroup="RateSetup"
                                                                                                        Display="Dynamic" ErrorMessage="[Maximum Quantity for Child Without Bed - Please enter Quantity.]"
                                                                                                        runat="server" ControlToValidate="txtChildWithOutBedMaxQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValChildWithOutBedMaxQty" ResourceName="compValChildWithOutBedMaxQty" ValidationGroup="RateSetup"
                                                                                                        runat="server" ControlToValidate="txtChildWithOutBedMaxQty"
                                                                                                        Display="Dynamic"
                                                                                                        ErrorMessage="Maximum Quantity for Child Without Bed - Please enter numeric data."
                                                                                                        Operator="DataTypeCheck"
                                                                                                        Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValChildWithOutBedMaxQty" ResourceName="custValChildWithOutBedMaxQty" runat="server"
                                                                                                        Display="Dynamic" ValidationGroup="RateSetup"
                                                                                                        ErrorMessage="Maximum Quantity for Child Without Bed - Please Enter Maximum Quantity Greater than 0."
                                                                                                        ClientValidationFunction="custValRateTextBox">
                                                                                                    </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="Pad-T10">
                                                                                        <actl:Label ID="lblPerInfant" runat="server" CssClass="Label"
                                                                                            Text="Package Price (Per Infant)">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <!-- hide below td by jignesh as per suggession by dhimant bhai because comment is not used any where -->
                                                                                    <td class="Pad-T10 Pad-L7" style="display: none">
                                                                                        <actl:TextBox ID="txtInfantComment" runat="server" MaxLength="200">
                                                                                        </actl:TextBox>
                                                                                    </td>
                                                                                    <td class="Pad-L20 Pad-T10">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtInfantPrice" SkinID="MandatoryTextBox" Width="130px" runat="server"
                                                                                                        MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValInfant" ValidationGroup="RateSetup" Display="Dynamic"
                                                                                                        ErrorMessage="[Please enter Price for Infant.]" runat="server" ControlToValidate="txtInfantPrice"
                                                                                                        ResourceName="reqValInfant" />
                                                                                                </td>
                                                                                                <%--<td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValInfantPrice" runat="server" ControlToValidate="txtInfantPrice"
                                                                                                        Display="Dynamic" ErrorMessage="[Price for Infant - Please enter valid data.]"
                                                                                                        Operator="DataTypeCheck" ResourceName="regExpInfant" ValidationGroup="RateSetup"
                                                                                                        Type="Currency">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>--%>
                                                                                                <td class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValCFRatesInfantPrice" ResourceName="regExpInfant"
                                                                                                        ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule"
                                                                                                        ValidationGroup="RateSetup" runat="server" ControlToValidate="txtInfantPrice"
                                                                                                        ClientValidationFunction="custValRateTextBox" ErrorMessage="[Price for Infant - Please enter valid data.]"
                                                                                                        Display="Dynamic"> </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtInfantMinQty" SkinID="MandatoryTextBox" Width="130px" runat="server"
                                                                                                        MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValInfantMinQty" ValidationGroup="RateSetup"
                                                                                                        Display="Dynamic" ErrorMessage="[Minimum Quantity for Infant - Please enter Quantity.]"
                                                                                                        runat="server" ControlToValidate="txtInfantMinQty" ResourceName="reqValInfantMinQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValInfantMinQty" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtInfantMinQty" Display="Dynamic" ErrorMessage="[Minimum Quantity for Infant - Please enter numeric data.]"
                                                                                                        Operator="DataTypeCheck" ResourceName="compValInfantMinQty" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtInfantMaxQty" SkinID="MandatoryTextBox" Width="130px" runat="server"
                                                                                                        MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" valign="top" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValInfantMaxQty" ValidationGroup="RateSetup"
                                                                                                        Display="Dynamic" ErrorMessage="[Maximum Quantity for Infant - Please enter Quantity.]"
                                                                                                        runat="server" ControlToValidate="txtInfantMaxQty" ResourceName="reqValInfantMaxQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValInfantMaxQty" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtInfantMaxQty" Display="Dynamic" ErrorMessage="[Maximum Quantity for Infant - Please enter numeric data.]"
                                                                                                        Operator="DataTypeCheck" ResourceName="compValInfantMaxQty" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValInfantMaxQty" runat="server" ResourceName="custValInfantMaxQty"
                                                                                                        Display="Dynamic" ValidationGroup="RateSetup" ErrorMessage="[Maximum Quantity for Infant - Please Enter Maximum Quantity Greater than 0.]"
                                                                                                        ClientValidationFunction="fnCheckMaxInfantQuantity" ResourceBaseName="ExcursionExtranetWeb.MemberAdmin.AddEditExcursionRateSchedule">
                                                                                                    </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="Pad-T10">
                                                                                        <actl:Label ID="lblSingleAdultPrice" runat="server" CssClass="Label" Text="Single Occupancy">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <td class="Pad-T10 Pad-L7" style="display: none">
                                                                                        <actl:TextBox ID="txtSingleAdultPriceComment" runat="server" MaxLength="200">
                                                                                        </actl:TextBox>
                                                                                    </td>
                                                                                    <td class="Pad-L20 Pad-T10">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtSingleAdultPrice" SkinID="MandatoryTextBox" Width="130px" runat="server" MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValSingleAdult" ResourceName="reqValSingleAdult" ValidationGroup="RateSetup" Display="Dynamic" ErrorMessage="Please enter Single Occupancy Price."
                                                                                                        runat="server" ControlToValidate="txtSingleAdultPrice" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:CompareValidator ID="comptxtSingleAdultPrice" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtSingleAdultPrice" Display="Dynamic" ErrorMessage="[Price for Single Occupancy - Please Enter Greater than 0.]"
                                                                                                        Operator="GreaterThan"  Type="Double">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                                <td class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValCFRatesSingleAdultPrice" ResourceName="custValCFRatesSingleAdultPrice" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtSingleAdultPrice" ClientValidationFunction="custValRateTextBox" ErrorMessage="[Price for Single Adult - Please enter valid data.]" Display="Dynamic"> </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtSingleAdultPriceMinQty" SkinID="MandatoryTextBox" Width="130px" runat="server" MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValSingleAdultMinQty" ResourceName="reqValSingleAdultMinQty" ValidationGroup="RateSetup" Display="Dynamic" ErrorMessage="[Minimum Quantity for Single Adult - Please enter Quantity.]" runat="server" ControlToValidate="txtSingleAdultPriceMinQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValSingleAdultMinQty" ResourceName="compValSingleAdultMinQty" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtSingleAdultPriceMinQty" Display="Dynamic"
                                                                                                        ErrorMessage="[Minimum Quantity for Single Adult - Please enter numeric data.]"
                                                                                                        Operator="DataTypeCheck" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtSingleAdultMaxQty" SkinID="MandatoryTextBox" Width="130px" runat="server" MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" valign="top" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValSingleAdultMaxQty" ResourceName="reqValSingleAdultMaxQty" ValidationGroup="RateSetup"
                                                                                                        Display="Dynamic" ErrorMessage="[Maximum Quantity for Single Adult - Please enter Quantity.]"
                                                                                                        runat="server" ControlToValidate="txtSingleAdultMaxQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValSingleAdultMaxQty" ResourceName="compValSingleAdultMaxQty" ValidationGroup="RateSetup"
                                                                                                        runat="server" ControlToValidate="txtSingleAdultMaxQty"
                                                                                                        Display="Dynamic"
                                                                                                        ErrorMessage="Maximum Quantity for Single Adult - Please enter numeric data."
                                                                                                        Operator="DataTypeCheck"
                                                                                                        Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValSingleAdultMaxQty" ResourceName="custValSingleAdultMaxQty" runat="server"
                                                                                                        Display="Dynamic" ValidationGroup="RateSetup"
                                                                                                        ErrorMessage="Maximum Quantity for Single Adult - Please Enter Maximum Quantity Greater than 0."
                                                                                                        ClientValidationFunction="custValRateTextBox">
                                                                                                    </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="Pad-T10">
                                                                                        <actl:Label ID="lblExtraAdult" runat="server" CssClass="Label" Text="Extra Adult Price">
                                                                                        </actl:Label>
                                                                                    </td>
                                                                                    <td class="Pad-T10 Pad-L7" style="display: none">
                                                                                        <actl:TextBox ID="txtExtraAdultComment" runat="server" MaxLength="200">
                                                                                        </actl:TextBox>
                                                                                    </td>
                                                                                    <td class="Pad-L20 Pad-T10">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtExtraAdult" SkinID="MandatoryTextBox" Width="130px" runat="server" MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValExtraAdult" ResourceName="reqValExtraAdult" ValidationGroup="RateSetup" Display="Dynamic" ErrorMessage="Please enter Extra Price for Adult."
                                                                                                        runat="server" ControlToValidate="txtExtraAdult" />
                                                                                                </td>
                                                                                                <td class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValCFRatesExtraAdult" ResourceName="custValCFRatesExtraAdult" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtExtraAdult" ClientValidationFunction="custValRateTextBox"
                                                                                                        ErrorMessage="[Price for Extra Adult - Please enter valid data.]" Display="Dynamic"> </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtExtraAdultMinQty" SkinID="MandatoryTextBox" Width="130px" runat="server" MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="RequiredFieldValidator1" ResourceName="RequiredFieldValidator1" ValidationGroup="RateSetup"
                                                                                                        Display="Dynamic"
                                                                                                        ErrorMessage="[Minimum Quantity for Extra Adult - Please enter Quantity.]" runat="server" ControlToValidate="txtExtraAdultMinQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValExtraAdultMinQty" ResourceName="compValExtraAdultMinQty" ValidationGroup="RateSetup" runat="server"
                                                                                                        ControlToValidate="txtExtraAdultMinQty" Display="Dynamic"
                                                                                                        ErrorMessage="[Minimum Quantity for Extra Adult - Please enter numeric data.]"
                                                                                                        Operator="DataTypeCheck" Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td class="Pad-L10 Pad-T10" style="display: none">
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <actl:TextBox ID="txtExtraAdultMaxQty" SkinID="MandatoryTextBox" Width="130px" runat="server" MaxLength="12" Text="0">
                                                                                                    </actl:TextBox>
                                                                                                </td>
                                                                                                <td align="left" valign="top" class="Pad-L5">
                                                                                                    <actl:RequiredFieldValidator ID="reqValExtraAdultMaxQty" ResourceName="reqValExtraAdultMaxQty" ValidationGroup="RateSetup"
                                                                                                        Display="Dynamic" ErrorMessage="[Maximum Quantity for Extra Adult - Please enter Quantity.]"
                                                                                                        runat="server" ControlToValidate="txtExtraAdultMaxQty" />
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CompareValidator ID="compValExtraAdultMaxQty" ResourceName="compValExtraAdultMaxQty" ValidationGroup="RateSetup"
                                                                                                        runat="server" ControlToValidate="txtExtraAdultMaxQty"
                                                                                                        Display="Dynamic"
                                                                                                        ErrorMessage="Maximum Quantity for Extra Adult - Please enter numeric data."
                                                                                                        Operator="DataTypeCheck"
                                                                                                        Type="Integer">
                                                                                                    </actl:CompareValidator>
                                                                                                </td>
                                                                                                <td align="left" class="Pad-L2">
                                                                                                    <actl:CustomValidator ID="custValExtraAdultMaxQty" ResourceName="custValExtraAdultMaxQty" runat="server"
                                                                                                        Display="Dynamic" ValidationGroup="RateSetup"
                                                                                                        ErrorMessage="Maximum Quantity for Extra Adult - Please Enter Maximum Quantity Greater than 0."
                                                                                                        ClientValidationFunction="custValRateTextBox">
                                                                                                    </actl:CustomValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>&nbsp;</td>
                                                                                    <td>&nbsp;</td>
                                                                                </tr>
                                                                                <asp:Repeater ID="repLocationPrice" runat="server">
                                                                                    <HeaderTemplate>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td valign="top" align="left">
                                                                                                <actl:Label ID="lblLocationName" SkinID="LabelBold" runat="server" Text="Location">
                                                                                                </actl:Label>
                                                                                            </td>
                                                                                            <td class="Pad-L7" valign="top" align="left">
                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td align="left" valign="top">
                                                                                                            <actl:Label ID="lblLocationPrice" SkinID="LabelBold" runat="server" Text="Price (in Rs.)" Style="padding: 15px !important">
                                                                                                            </actl:Label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </HeaderTemplate>
                                                                                    <ItemTemplate>
                                                                                        <%# (Convert.ToInt32(Eval("Rno")) == 1) ? "<tr>" : ""  %>
                                                                                        <td class="Pad-T10">
                                                                                            <actl:Label ID="lblLocationPrice" runat="server" CssClass="Label" Text='<%# Eval("ActivityLocation") %>'>
                                                                                            </actl:Label>
                                                                                            <actl:HiddenField Value='<%# Eval("LocationID") %>' ID="hdLocationPriceID" runat="server"></actl:HiddenField>
                                                                                        </td>
                                                                                        <td class="Pad-L20 Pad-T10">
                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td align="left">
                                                                                                        <actl:TextBox ID="txtLocationPrice" SkinID="MandatoryTextBox" Width="130px" runat="server" MaxLength="12" Text="0" Style="text-align: right;">
                                                                                                        </actl:TextBox>
                                                                                                    </td>
                                                                                                    <td align="left" class="Pad-L5">
                                                                                                        <actl:RequiredFieldValidator ID="reqLocationPrice" ResourceName="reqLocationPrice" ValidationGroup="RateSetup" Display="Dynamic" ErrorMessage="Please enter Location Price." runat="server" ControlToValidate="txtLocationPrice" />
                                                                                                    </td>
                                                                                                    <td class="Pad-L2">&nbsp;
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                        <%# (Convert.ToInt32(Eval("Rno")) % 3 == 0) ? "</tr><tr>" : ""  %>
                                                                                    </ItemTemplate>
                                                                                </asp:Repeater>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="Pad-T10" align="left" colspan="2">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td>
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <actl:Button ID="ibtnSaveInsert" runat="server" Text="[Save]" ToolTip="[Save]" OnClick="ibtnSaveInsert_Click"
                                                                                                    CausesValidation="true" ValidationGroup="RateSetup" ConfirmMessageType="SaveConfirm"></actl:Button>
                                                                                            </td>
                                                                                            <td class="Pad-L7">
                                                                                                <actl:Button ID="ibtnCancelInsert" runat="server" CausesValidation="False" Text="[Cancel]"
                                                                                                    ToolTip="[Cancel]" OnClick="ibtnCancelInsert_Click"></actl:Button>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <actl:HiddenField ID="hidInsert" runat="server" />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                    <!--list table ends here-->
                                                </td>
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
        <!-- End for Configure Schedule Wise Rate -->
        
    </table>
    <%--<cc1:esDataSource ID="esRatesDS" runat="server" AutoPaging="true" AutoSorting="true"
        OnesSelect="esRatesDS_esSelect" OnesCreateEntity="esRatesDS_esCreateEntity" />--%>
    <asp:HiddenField runat="server" ID="hdfData" />

    <script language="javascript" type="text/javascript">
        function EnableAllValidations() {
            var reqValInsertQuantity = document.getElementById('<%=reqValInsertQuantity.ClientID %>');
            var regExpValInsertQuantity = document.getElementById('<%=regExpValInsertQuantity.ClientID %>');
            var custValTime = document.getElementById('<%=custValTime.ClientID %>');
            reqValInsertQuantity.enabled = true;
            regExpValInsertQuantity.enabled = true;
            custValTime.enabled = true;
        }
        function EmptyMessage() {
            var lblMsg = '<%=lblMsg.ClientID %>';
            var messasge = window.document.getElementById(lblMsg);
            if (messasge != null) {
                messasge.innerHTML = "";

                var pageMode = document.getElementById('<%=hdfData.ClientID %>');
                var reqValInsertQuantity = document.getElementById('<%=reqValInsertQuantity.ClientID %>');
                var regExpValInsertQuantity = document.getElementById('<%=regExpValInsertQuantity.ClientID %>');
                var custValTime = document.getElementById('<%=custValTime.ClientID %>');
                var hidInsert = document.getElementById('<%=hidInsert.ClientID %>');
                var custValTimeOverlap = document.getElementById('<%=custValTimeOverlap.ClientID %>');

                if (pageMode.value == "Edit") {

                    reqValInsertQuantity.enabled = false;
                    regExpValInsertQuantity.enabled = false;
                    custValTime.enabled = false;
                    custValTimeOverlap.enabled = false;
                }
                else if (hidInsert.value == "insert") {
                    reqValInsertQuantity.enabled = false;
                    regExpValInsertQuantity.enabled = false;
                    custValTime.enabled = false;
                    custValTimeOverlap.enabled = false;

                }
                else {
                    reqValInsertQuantity.enabled = true;
                    regExpValInsertQuantity.enabled = true;
                    custValTime.enabled = true;
                    custValTimeOverlap.enabled = true;
                }
            }
        }

        function SelectStartTime(sender, e) {
            var ddlHour = document.getElementById("<%=ddlHour.ClientID %>");
            var ddlMinute = document.getElementById("<%=ddlMinute.ClientID %>");

            if (ddlHour.value == "0" || ddlMinute.value == "0") {
                e.IsValid = false;
            }
            else {
                e.IsValid = true;
            }
        }
        function fnValidateCommission(sender, args) {
            var Commission = fnConvertToUSFormat(args.Value);
            args.IsValid = false;
            if (Commission != NaN && Commission >= 0) {
                if (document.getElementById('<%= rbPercentageCommossion.ClientID %>').checked) {
                    if (Commission <= 100)
                        args.IsValid = true;
                }
                else
                    args.IsValid = true;
            }
        }
    </script>

</asp:Content>
