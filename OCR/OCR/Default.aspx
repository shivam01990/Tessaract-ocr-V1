<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" EnableEventValidation="true" Inherits="OCRExtractTable.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>OCR App</title>

    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <style>
        body {
            padding-top: 70px;
            /* Required padding for .navbar-fixed-top. Remove if using .navbar-static-top. Change if height of navigation changes. */
        }
    </style>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->


    <link href="content/bootstrap-fileinput/css/fileinput.css" rel="stylesheet" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script src="js/jquery.browser.js"></script>
    <script type="text/javascript" src="js/fileinput.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script src="js/fileinput_locale_LANG.js"></script>
    <script src="js/jquery.Jcrop.js"></script>
    <link href="css/jquery.Jcrop.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript">
        var rootpath = '<%=Page.ResolveUrl("~")%>';
        $(document).ready(function () {
            $("[id$=txtColumns]").change(function () {
                var totalColumns = 0;
                var distributedwidth = 0;
                if (!isNaN(parseInt($("[id$=txtColumns]").val()))) {
                    totalColumns = parseInt($("[id$=txtColumns]").val());
                }

                if (totalColumns > 0) {
                    distributedwidth = (100 / totalColumns).toFixedDown(2);
                }
                var totalwitdhsum = 0;
                var appendhtml = "";
                var colstring = "";
                for (var i = 0; i < totalColumns; i++) {
                    appendhtml += " <div class=\"form-group\">";
                    appendhtml += "  <div class=\"col-sm-2\">";
                    appendhtml += "    <label class=\"control-label\">Columns " + (i + 1) + " width(%)</label>";
                    appendhtml += "  </div>";
                    appendhtml += "  <div class=\"col-sm-5\">";
                    appendhtml += "   <input id=\"txtwidthcolumn_" + i + "\" type=\"text\" class=\"form-control\" onchange=\"readAlltextbox()\" value=\"" + distributedwidth + "\"/>";
                    appendhtml += "  </div>";
                    appendhtml += " </div>";
                    totalwitdhsum = (parseFloat(totalwitdhsum) + parseFloat(distributedwidth));
                    colstring += distributedwidth + ",";
                }
                if (colstring.length > 0) {
                    colstring = colstring.substring(0, colstring.length - 1);
                }

                appendhtml += " <div class=\"form-group\">";
                appendhtml += "  <div class=\"col-sm-2\">";
                appendhtml += "    <label class=\"control-label\">Total Width(%) of Columns</label>";
                appendhtml += "  </div>";
                appendhtml += "  <div class=\"col-sm-5\">";
                if (totalwitdhsum > 100) {
                    appendhtml += "   <label id=\"lbltotalwidthper\" class=\"control-label text-danger\">" + totalwitdhsum + "</label>";
                } else {
                    appendhtml += "   <label id=\"lbltotalwidthper\" class=\"control-label text-success\">" + totalwitdhsum + "</label>";
                }
                appendhtml += "  </div>";
                appendhtml += " </div>";
                $("[id$=divcolumnwidth]").html(appendhtml);
                $("[id$=hdnColumnWidths]").val(colstring);
                return false;
            });


            $("#file_BrandImage").fileinput({
                uploadUrl: rootpath + 'FileUploadHandler.ashx',
                uploadAsync: true,
                allowedFileExtensions: ['jpg', 'png', 'gif']
            });

            $("#file_BrandImage").on('fileuploaded', function (event, data, previewId, index) {
                //var form = data.form, files = data.files, extra = data.extra,
                //    response = data.response, reader = data.reader; 
                $.each(data.files, function (k, obj) {
                    $("[id$=hdnUploadedImage]").val(obj["name"]);
                    $("[id$=imgUpload]").attr('src', rootpath + "uploads/" + $("[id$=hdnUploadedImage]").val())
                    $("[id$=ocr-sec]").show();

                    $('#<%=imgUpload.ClientID%>').Jcrop({
                        onSelect: SelectCropArea
                    });

                });
            })

            $('#file_BrandImage').on('fileclear', function (event) {
                $("[id$=hdnUploadedImage]").val('');
                $("[id$=ocr-sec]").hide();
            });

        });


        function SelectCropArea(c) {
            $('#<%=X.ClientID%>').val(parseInt(c.x));
            $('#<%=Y.ClientID%>').val(parseInt(c.y));
            $('#<%=W.ClientID%>').val(parseInt(c.w));
            $('#<%=H.ClientID%>').val(parseInt(c.h));
        }



        function readAlltextbox() {
            var flag = false;
            var colstring = "";
            var totalwitdhsum = 0;
            $("[id^=txtwidthcolumn_]").each(function () {

                totalwitdhsum = (parseFloat(totalwitdhsum) + parseFloat($(this).val()));
                colstring += $(this).val() + ",";
            });
            if (colstring.length > 0) {
                colstring = colstring.substring(0, colstring.length - 1);
            }
            $("[id$=hdnColumnWidths]").val(colstring);
            $("[id$=lbltotalwidthper]").text(totalwitdhsum);
            if (totalwitdhsum > 100) {
                alert("Total width shoud be less than 100%");
            } else {
                flag = true;
            }
            return flag;
        }


        Number.prototype.toFixedDown = function (digits) {
            var re = new RegExp("(\\d+\\.\\d{" + digits + "})(\\d)"),
                m = this.toString().match(re);
            return m ? parseFloat(m[1]) : this.valueOf();
        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navigation -->
        <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
            <div class="container">
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="#">OCR APP</a>
                </div>
                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
                    </ul>
                </div>
                <!-- /.navbar-collapse -->
            </div>
            <!-- /.container -->
        </nav>

        <!-- Page Content -->
        <div class="container">
            <div class="row">
                <h2>
                    <label>Upload File</label></h2>
                <div class="col-sm-12 text-center">
                    <input id="file_BrandImage" type="file" data-min-file-count="1">
                </div>
            </div>
            <!-- /.row -->
            <div id="ocr-sec" style="display: none;" class="col-sm-12">
                <div class="row">
                    <h2>
                        <label>Upload File Preview</label></h2>
                    <div class="form-horizontal">
                        <div class="form-group">

                            <asp:Image ID="imgUpload" runat="server" />
                        </div>
                        <div class="form-group">
                            <label for="inputEmail3" class="col-sm-2 control-label">Total Columns</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="txtColumns" runat="server" class="form-control" placeholder="Columns"></asp:TextBox>
                            </div>

                        </div>
                        <div id="divcolumnwidth">
                        </div>
                        <div class="form-group">
                            <asp:Button ID="btnOCRReader" runat="server" Text="Read Image Data" CssClass="btn btn-primary" OnClick="btnOCRReader_Click" OnClientClick="return readAlltextbox();" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.container -->
        <asp:HiddenField ID="hdnUploadedImage" runat="server" />
        <asp:HiddenField ID="X" runat="server" />
        <asp:HiddenField ID="Y" runat="server" />
        <asp:HiddenField ID="W" runat="server" />
        <asp:HiddenField ID="H" runat="server" />
        <asp:HiddenField ID="hdnColumnWidths" runat="server" />
    </form>
</body>
</html>
