﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="phuongthucthanhtoan.aspx.cs" Inherits="phuongthucthanhtoan" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <link rel="shortcut icon" href="<%= clsConfig.GetHostUrl() %>/theme.hstatic.net/1000177652/1000229231/14/favicon.png?v=90"
        type="image/png" />
    <title>OxyWatch - Thanh toán đơn hàng </title>
    <meta charset="utf-8" />
    <meta name="description" content="OxyWatch - Thanh to&#225;n đơn h&#224;ng" />
    <link href='./hstatic.net/0/0/global/checkouts.css?v=1.1' rel='stylesheet' type='text/css'
        media='all' />
    <link href='./theme.hstatic.net/1000177652/1000229231/14/check_out.css?v=90' rel='stylesheet'
        type='text/css' media='all' />
    <script src='./hstatic.net/0/0/global/jquery.min.js' type='text/javascript'></script>
    <script src='./hstatic.net/0/0/global/jquery.validate.js' type='text/javascript'></script>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=2, user-scalable=no">
    <script type="text/javascript">
        window.onpageshow = function (event) {
            if (event.persisted) {
                var currentUrl = '';


                currentUrl = 'http://happylive.vn/checkouts/9da4ac7a14de46fdba068d4f8f789d15?step=2';


                if (currentUrl)
                    window.location = currentUrl;
            }
        };



        var isInit = false;

        function funcFormOnSubmit(e) {

            if (!isInit) {
                isInit = true;

                $.fn.tagName = function () {
                    return this.prop("tagName").toLowerCase();
                };
            }

            if (typeof (e) == 'string') {
                var element = $(e);
                var formData = e;
            } else {
                var element = this;
                var formData = this;
                e.preventDefault();
            }

            $(element).find('button:submit').addClass('btn-loading');

            var formId = $(element).attr('id'), replaceElement = [], funcCallback;

            if (formId == undefined || formId == null || formId == '')
                return;



            if (formId == 'form_next_step') {
                formData = '#section-payment-method';
                replaceElement.push('.step-sections');
            }
            else if (
									formId == 'form_discount_add'
									|| formId == 'form_discount_remove'

										|| formId == 'section-shipping-rate'

									) {

                replaceElement.push('#section-shipping-rate');

                replaceElement.push('.order-summary-toggle-inner .order-summary-toggle-total-recap');
                replaceElement.push('.order-summary-sections');
            }



            if (!$(formData) || $(formData).length == 0) {
                window.location.reload();
                return false;
            }

            if ($(formData).tagName() != 'form')
                formData += ' :input';

            $.ajax({
                type: 'GET',
                url: window.location.origin + window.location.pathname + '?' + $(formData).serialize() + encodeURI('&form_name=' + formId),
                success: function (html) {

                    if ($(html).attr('id') == 'redirect-url') {
                        window.location = $(html).val();
                    } else {
                        if (replaceElement.length > 0) {
                            for (var i = 0; i < replaceElement.length; i++) {
                                var tempElement = replaceElement[i];
                                var newElement = $(html).find(tempElement);

                                if (newElement.length > 0) {
                                    if (tempElement == '.step-sections')
                                        $(tempElement).attr('step', $(newElement).attr('step'));

                                    var listTempElement = $(tempElement);

                                    for (var j = 0; j < newElement.length; j++)
                                        if (j < listTempElement.length)
                                            $(listTempElement[j]).html($(newElement[j]).html());
                                }
                            }
                        }

                        $('body').attr('src', $(html).attr('src'));
                        $(element).find('button:submit').removeClass('btn-loading');

                        if (($('body').find('.field-error') && $('body').find('.field-error').length > 0)
                                            || ($('body').find('.has-error') && $('body').find('.has-error').length > 0))
                            $("html, body").animate({ scrollTop: 0 }, "slow");

                        if (funcCallback)
                            funcCallback();
                    }
                }
            });

            return false;
        };
        function funcSetEvent() {
            var effectControlFieldClass = '.field input, .field select, .field textarea';

            $('body')
								.on('focus', effectControlFieldClass, function () {
								    funcFieldFocus($(this), true);
								})
								.on('blur', effectControlFieldClass, function () {
								    funcFieldFocus($(this), false);
								    funcFieldHasValue($(this), true);
								})
								.on('keyup input paste', effectControlFieldClass, function () {
								    funcFieldHasValue($(this), false);
								})
								.on('submit', 'form', funcFormOnSubmit);




            $('body')
									.on('change', '#section-payment-method input:radio', function () {
									    $('#section-payment-method .content-box-row.content-box-row-secondary').addClass('hidden');

									    var id = $(this).attr('id');

									    if (id) {
									        var sub = $('body').find('.content-box-row.content-box-row-secondary[for=' + id + ']')

									        if (sub && sub.length > 0) {
									            $(sub).removeClass('hidden');
									        }
									    }
									});



            $('body')
										.on('change', '#section-shipping-rate input:radio[name=shipping_rate_id]', function () {
										    funcFormOnSubmit('#section-shipping-rate');
										});






        };
        function funcFieldFocus(fieldInputElement, isFocus) {
            if (fieldInputElement == undefined)
                return;

            var fieldElement = $(fieldInputElement).closest('.field');

            if (fieldElement == undefined)
                return;

            if (isFocus)
                $(fieldElement).addClass('field-active');
            else
                $(fieldElement).removeClass('field-active');
        };
        function funcFieldHasValue(fieldInputElement, isCheckRemove) {
            if (fieldInputElement == undefined)
                return;

            var fieldElement = $(fieldInputElement).closest('.field');

            if (fieldElement == undefined)
                return;

            if ($(fieldElement).find('.field-input-wrapper-select').length > 0) {
                var value = $(fieldInputElement).find(':selected').val();

                if (value == 'null')
                    value = undefined;
            } else {
                var value = $(fieldInputElement).val();
            }

            if (!isCheckRemove) {
                if (value != $(fieldInputElement).attr('value'))
                    $(fieldElement).removeClass('field-error');
            }

            var fieldInputBtnWrapperElement = $(fieldInputElement).closest('.field-input-btn-wrapper');

            if (value && value.trim() != '') {
                $(fieldElement).addClass('field-show-floating-label');
                $(fieldInputBtnWrapperElement).find('button:submit').removeClass('btn-disabled');
            }
            else if (isCheckRemove) {
                $(fieldElement).removeClass('field-show-floating-label');
                $(fieldInputBtnWrapperElement).find('button:submit').addClass('btn-disabled');
            }
            else {
                $(fieldInputBtnWrapperElement).find('button:submit').addClass('btn-disabled');
            }
        };
        function funcInit() {
            funcSetEvent();


        }
        $(document).ready(function () {
            funcInit();
        });
    </script>
    <script type="text/javascript">
        var toggleShowOrderSummary = false;
        $(document).ready(function () {
            var currentUrl = '';


            currentUrl = 'http://happylive.vn/checkouts/9da4ac7a14de46fdba068d4f8f789d15?step=2';


            if ($('#reloadValue').val().length == 0) {
                $('#reloadValue').val(currentUrl);
                $('body').show();
            }
            else {
                window.location = $('#reloadValue').val();
                $('#reloadValue').val('');
            }

            $('body')
							.on('click', '.order-summary-toggle', function () {
							    toggleShowOrderSummary = !toggleShowOrderSummary;

							    if (toggleShowOrderSummary) {
							        $('.order-summary-toggle')
										.removeClass('order-summary-toggle-hide')
										.addClass('order-summary-toggle-show');

							        $('.sidebar:not(".sidebar-second") .sidebar-content .order-summary')
										.removeClass('order-summary-is-collapsed')
										.addClass('order-summary-is-expanded');

							        $('.sidebar.sidebar-second .sidebar-content .order-summary')
										.removeClass('order-summary-is-expanded')
										.addClass('order-summary-is-collapsed');
							    } else {
							        $('.order-summary-toggle')
										.removeClass('order-summary-toggle-show')
										.addClass('order-summary-toggle-hide');

							        $('.sidebar:not(".sidebar-second") .sidebar-content .order-summary')
										.removeClass('order-summary-is-expanded')
										.addClass('order-summary-is-collapsed');

							        $('.sidebar.sidebar-second .sidebar-content .order-summary')
										.removeClass('order-summary-is-collapsed')
										.addClass('order-summary-is-expanded');
							    }
							});
        });
    </script>
    <script>
//<![CDATA[
        (function (i, s, o, g, r, a, m) {
            i['GoogleAnalyticsObject'] = r; i[r] = i[r] || function () {
                (i[r].q = i[r].q || []).push(arguments)
            }, i[r].l = 1 * new Date(); a = s.createElement(o),
m = s.getElementsByTagName(o)[0]; a.async = 1; a.src = g; m.parentNode.insertBefore(a, m)
        })(window, document, 'script', './www.google-analytics.com/analytics.js', 'ga');
        ga('create', 'UA-97086989-1', 'auto');
        try {

        } catch (e) { };
        ga('send', 'pageview');

//]]>
    </script>
    <script>
//<![CDATA[
        !function (f, b, e, v, n, t, s) {
            if (f.fbq) return; n = f.fbq = function () {
                n.callMethod ?
n.callMethod.apply(n, arguments) : n.queue.push(arguments)
            }; if (!f._fbq) f._fbq = n;
            n.push = n; n.loaded = !0; n.version = '2.0'; n.queue = []; t = b.createElement(e); t.async = !0;
            t.src = v; s = b.getElementsByTagName(e)[0]; s.parentNode.insertBefore(t, s)
        } (window,
document, 'script', './connect.facebook.net/en_US/fbevents.js');
        // Insert Your Facebook Pixel ID below. 
        fbq('init', '905600829489553');
        fbq('track', 'PageView');
//]]>
    </script>
    <noscript>
        <img height='1' width='1' style='display: none' src='https://www.facebook.com/tr?id=905600829489553&amp;ev=PageView&amp;noscript=1' /></noscript>
    <script type='text/javascript'>
//<![CDATA[
        if ((typeof Haravan) === 'undefined') {
            Haravan = {};
        }
        Haravan.culture = 'vi-VN';
        Haravan.shop = 'happylive.myharavan.com';
        Haravan.theme = { "name": "Theme mặc định", "id": 1000229231, "role": "main" };
        Haravan.domain = 'happylive.vn';
//]]>
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <input id="reloadValue" type="hidden" name="reloadValue" value="" />
    <div class="banner">
        <div class="wrap">
            <a href="http://happylive.vn" class="logo">
                <h1 class="logo-text">
                    OxyWatch</h1>
            </a>
        </div>
    </div>
    <button class="order-summary-toggle order-summary-toggle-hide">
        <div class="wrap">
            <div class="order-summary-toggle-inner">
                <div class="order-summary-toggle-icon-wrapper">
                    <svg width="20" height="19" xmlns="http://www.w3.org/2000/svg" class="order-summary-toggle-icon"><path d="M17.178 13.088H5.453c-.454 0-.91-.364-.91-.818L3.727 1.818H0V0h4.544c.455 0 .91.364.91.818l.09 1.272h13.45c.274 0 .547.09.73.364.18.182.27.454.18.727l-1.817 9.18c-.09.455-.455.728-.91.728zM6.27 11.27h10.09l1.454-7.362H5.634l.637 7.362zm.092 7.715c1.004 0 1.818-.813 1.818-1.817s-.814-1.818-1.818-1.818-1.818.814-1.818 1.818.814 1.817 1.818 1.817zm9.18 0c1.004 0 1.817-.813 1.817-1.817s-.814-1.818-1.818-1.818-1.818.814-1.818 1.818.814 1.817 1.818 1.817z"></path></svg>
                </div>
                <div class="order-summary-toggle-text order-summary-toggle-text-show">
                    <span>Hiển thị thông tin đơn hàng</span>
                    <svg width="11" height="6" xmlns="http://www.w3.org/2000/svg" class="order-summary-toggle-dropdown"
                        fill="#000"><path d="M.504 1.813l4.358 3.845.496.438.496-.438 4.642-4.096L9.504.438 4.862 4.534h.992L1.496.69.504 1.812z"></path></svg>
                </div>
                <div class="order-summary-toggle-text order-summary-toggle-text-hide">
                    <span>Ẩn thông tin đơn hàng</span>
                    <svg width="11" height="7" xmlns="http://www.w3.org/2000/svg" class="order-summary-toggle-dropdown"
                        fill="#000"><path d="M6.138.876L5.642.438l-.496.438L.504 4.972l.992 1.124L6.138 2l-.496.436 3.862 3.408.992-1.122L6.138.876z"></path></svg>
                </div>
                <div class="order-summary-toggle-total-recap" data-checkout-payment-due-target="619400000">
                    <span class="total-recap-final-price">6,194,000₫</span>
                </div>
            </div>
        </div>
    </button>
    <div class="content content-second">
        <div class="wrap">
            <div class="sidebar sidebar-second">
                <div class="sidebar-content">
                    <div class="order-summary">
                        <div class="order-summary-sections">
                            <div class="order-summary-section order-summary-section-discount" data-order-summary-section="discount">
                                <form id="form_discount_add" accept-charset="UTF-8" method="post">
                                <input name="utf8" type="hidden" value="✓">
                                <div class="fieldset">
                                    <div class="field  ">
                                        <div class="field-input-btn-wrapper">
                                            <div class="field-input-wrapper">
                                                <label class="field-label" for="discount.code">
                                                    Mã giảm giá</label>
                                                <input placeholder="Mã giảm giá" class="field-input" data-discount-field="true" autocomplete="off"
                                                    autocapitalize="off" spellcheck="false" size="30" type="text" id="discount.code"
                                                    name="discount.code" value="" />
                                            </div>
                                            <button type="submit" class="field-input-btn btn btn-default btn-disabled">
                                                <span class="btn-content">Sử dụng</span> <i class="btn-spinner icon icon-button-spinner">
                                                </i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="content">
        <div class="wrap">
            <div class="sidebar">
                <div class="sidebar-content">
                    <div class="order-summary order-summary-is-collapsed">
                        <h2 class="visually-hidden">
                            Thông tin đơn hàng</h2>
                        <div class="order-summary-sections">
                            <div class="order-summary-section order-summary-section-product-list" data-order-summary-section="line-items">
                                <table class="product-table">
                                    <thead>
                                        <tr>
                                            <th scope="col">
                                                <span class="visually-hidden">Hình ảnh</span>
                                            </th>
                                            <th scope="col">
                                                <span class="visually-hidden">Mô tả</span>
                                            </th>
                                            <th scope="col">
                                                <span class="visually-hidden">Số lượng</span>
                                            </th>
                                            <th scope="col">
                                                <span class="visually-hidden">Giá</span>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="product" data-product-id="1004862902" data-variant-id="1012030836">
                                            <td class="product-image">
                                                <div class="product-thumbnail">
                                                    <div class="product-thumbnail-wrapper">
                                                        <img class="product-thumbnail-image" alt="ĐỒNG HỒ NAM SKMEI KIM XANH DƯƠNG" src="./product.hstatic.net/1000177652/product/1_e0ed7c0240734782a8268793dce0b9b8_small.jpg" />
                                                    </div>
                                                    <span class="product-thumbnail-quantity" aria-hidden="true">6</span>
                                                </div>
                                            </td>
                                            <td class="product-description">
                                                <span class="product-description-name order-summary-emphasis">ĐỒNG HỒ NAM SKMEI KIM
                                                    XANH DƯƠNG</span>
                                            </td>
                                            <td class="product-quantity visually-hidden">
                                                6
                                            </td>
                                            <td class="product-price">
                                                <span class="order-summary-emphasis">2,994,000₫</span>
                                            </td>
                                        </tr>
                                        <tr class="product" data-product-id="1004853557" data-variant-id="1012006173">
                                            <td class="product-image">
                                                <div class="product-thumbnail">
                                                    <div class="product-thumbnail-wrapper">
                                                        <img class="product-thumbnail-image" alt="ĐỒNG HỒ NAM TEVISE 1952 CHẠY CƠ CỰC CHẤT"
                                                            src="./product.hstatic.net/1000177652/product/7_0590d26379fb4da3ba8d9b57564ee6b0_small.jpg" />
                                                    </div>
                                                    <span class="product-thumbnail-quantity" aria-hidden="true">4</span>
                                                </div>
                                            </td>
                                            <td class="product-description">
                                                <span class="product-description-name order-summary-emphasis">ĐỒNG HỒ NAM TEVISE 1952
                                                    CHẠY CƠ CỰC CHẤT</span>
                                            </td>
                                            <td class="product-quantity visually-hidden">
                                                4
                                            </td>
                                            <td class="product-price">
                                                <span class="order-summary-emphasis">3,200,000₫</span>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="order-summary-section order-summary-section-discount" data-order-summary-section="discount">
                                <form id="form_discount_add" accept-charset="UTF-8" method="post">
                                <input name="utf8" type="hidden" value="✓">
                                <div class="fieldset">
                                    <div class="field  ">
                                        <div class="field-input-btn-wrapper">
                                            <div class="field-input-wrapper">
                                                <label class="field-label" for="discount.code">
                                                    Mã giảm giá</label>
                                                <input placeholder="Mã giảm giá" class="field-input" data-discount-field="true" autocomplete="off"
                                                    autocapitalize="off" spellcheck="false" size="30" type="text" id="discount.code"
                                                    name="discount.code" value="" />
                                            </div>
                                            <button type="submit" class="field-input-btn btn btn-default btn-disabled">
                                                <span class="btn-content">Sử dụng</span> <i class="btn-spinner icon icon-button-spinner">
                                                </i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                </form>
                            </div>
                            <div class="order-summary-section order-summary-section-total-lines" data-order-summary-section="payment-lines">
                                <table class="total-line-table">
                                    <thead>
                                        <tr>
                                            <th scope="col">
                                                <span class="visually-hidden">Mô tả</span>
                                            </th>
                                            <th scope="col">
                                                <span class="visually-hidden">Giá</span>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="total-line total-line-subtotal">
                                            <td class="total-line-name">
                                                Tạm tính
                                            </td>
                                            <td class="total-line-price">
                                                <span class="order-summary-emphasis" data-checkout-subtotal-price-target="619400000">
                                                    6,194,000₫ </span>
                                            </td>
                                        </tr>
                                        <tr class="total-line total-line-shipping">
                                            <td class="total-line-name">
                                                Phí vận chuyển
                                            </td>
                                            <td class="total-line-price">
                                                <span class="order-summary-emphasis" data-checkout-total-shipping-target="0">Miễn phí
                                                </span>
                                            </td>
                                        </tr>
                                    </tbody>
                                    <tfoot class="total-line-table-footer">
                                        <tr class="total-line">
                                            <td class="total-line-name payment-due-label">
                                                <span class="payment-due-label-total">Tổng cộng</span>
                                            </td>
                                            <td class="total-line-name payment-due">
                                                <span class="payment-due-currency">VND</span> <span class="payment-due-price" data-checkout-payment-due-target="619400000">
                                                    6,194,000₫ </span>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="main">
                <div class="main-header">
                    <a href="http://happylive.vn" class="logo">
                        <h1 class="logo-text">
                            OxyWatch</h1>
                    </a>
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item"><a href="http://happylive.vn/cart">Giỏ hàng</a> </li>
                        <li class="breadcrumb-item "><a href="http://happylive.vn/checkouts/9da4ac7a14de46fdba068d4f8f789d15?step=1"
                            class="breadcrumb-link">Thông tin giao hàng </a></li>
                        <li class="breadcrumb-item breadcrumb-item-current">Phương thức thanh toán </li>
                    </ul>
                </div>
                <div class="main-content">
                    <div class="step">
                        <div class="step-sections " step="2">
                            <div id="section-shipping-rate" class="section">
                                <div class="section-header">
                                    <h2 class="section-title">
                                        Phương thức vận chuyển</h2>
                                </div>
                                <div class="section-content">
                                    <div class="content-box">
                                        <div class="content-box-row">
                                            <div class="radio-wrapper">
                                                <label class="radio-label" for="shipping_rate_id_601017">
                                                    <div class="radio-input">
                                                        <input id="shipping_rate_id_601017" class="input-radio" type="radio" name="shipping_rate_id"
                                                            value="601017" checked />
                                                    </div>
                                                    <span class="radio-label-primary">Giao hàng tận nơi</span> <span class="radio-accessory content-box-emphasis">
                                                        0₫ </span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="section-payment-method" class="section">
                                <div class="section-header">
                                    <h2 class="section-title">
                                        Phương thức thanh toán</h2>
                                </div>
                                <div class="section-content">
                                    <div class="content-box">
                                        <div class="radio-wrapper content-box-row">
                                            <label class="radio-label" for="payment_method_id_485706">
                                                <div class="radio-input">
                                                    <input id="payment_method_id_485706" class="input-radio" name="payment_method_id"
                                                        type="radio" value="485706" checked />
                                                </div>
                                                <span class="radio-label-primary">Thanh toán khi giao hàng (COD)</span>
                                            </label>
                                        </div>
                                        <div class="radio-wrapper content-box-row">
                                            <label class="radio-label" for="payment_method_id_485708">
                                                <div class="radio-input">
                                                    <input id="payment_method_id_485708" class="input-radio" name="payment_method_id"
                                                        type="radio" value="485708" />
                                                </div>
                                                <span class="radio-label-primary">Chuyển khoản qua ngân hàng</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="step-footer">
                            <form id="form_next_step" accept-charset="UTF-8" method="post">
                            <input name="utf8" type="hidden" value="✓">
                            <button type="submit" class="step-footer-continue-btn btn">
                                <span class="btn-content">Hoàn tất đơn hàng</span> <i class="btn-spinner icon icon-button-spinner">
                                </i>
                            </button>
                            </form>
                            <a href="http://happylive.vn/checkouts/9da4ac7a14de46fdba068d4f8f789d15?step=1" class="step-footer-previous-link">
                                <svg class="previous-link-icon icon-chevron icon" xmlns="http://www.w3.org/2000/svg"
                                    width="6.7" height="11.3" viewbox="0 0 6.7 11.3"><path d="M6.7 1.1l-1-1.1-4.6 4.6-1.1 1.1 1.1 1 4.6 4.6 1-1-4.6-4.6z"></path></svg>
                                Quay lại thông tin giao hàng </a>
                        </div>
                    </div>
                </div>
                <div class="main-footer">
                </div>
            </div>
        </div>
    </div>
    </div>
    </form>
</body>
</html>
