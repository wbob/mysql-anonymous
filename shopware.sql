--
-- shopware.yml
--
SET @common_hash_secret=rand();
SET @shopware_schema_version = (SELECT MAX(version) FROM s_schema_version);

SET @disable_trigger = 1;
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE `s_core_sessions`;
TRUNCATE `s_core_sessions_backend`;
TRUNCATE `s_articles_also_bought_ro`;
TRUNCATE `s_articles_similar_shown_ro`;
TRUNCATE `s_articles_top_seller_ro`;
TRUNCATE `s_es_backlog`;
TRUNCATE `s_customer_search_index`;
TRUNCATE `s_emarketing_lastarticles`;
TRUNCATE `s_campaigns_logs`;
TRUNCATE `s_statistics_article_impression`;
TRUNCATE `s_statistics_search`;
TRUNCATE `s_statistics_visitors`;
UPDATE `s_articles_vote` SET `email` = CONCAT(LEFT(MD5(CONCAT(@common_hash_secret, `email`)), 12), '@localhost'), `name` = LEFT(MD5(CONCAT(@common_hash_secret, `name`)), LENGTH(`name`));
UPDATE `s_campaigns_mailaddresses` SET `email` = CONCAT(LEFT(MD5(CONCAT(@common_hash_secret, `email`)), 12), '@localhost');
UPDATE `s_campaigns_maildata` SET `firstname` = LEFT(MD5(CONCAT(@common_hash_secret, `firstname`)), LENGTH(`firstname`)), `lastname` = LEFT(MD5(CONCAT(@common_hash_secret, `lastname`)), LENGTH(`lastname`)), `street` = LEFT(MD5(CONCAT(@common_hash_secret, `street`)), LENGTH(`street`)), `email` = CONCAT(LEFT(MD5(CONCAT(@common_hash_secret, `email`)), 12), '@localhost');
UPDATE `s_core_auth` SET `username` = CONCAT('userid_', id), `name` = LEFT(MD5(CONCAT(@common_hash_secret, `name`)), LENGTH(`name`)), `email` = CONCAT(LEFT(MD5(CONCAT(@common_hash_secret, `email`)), 12), '@', SUBSTRING_INDEX(`email`, '@', -1)), `password` = '', `apiKey` = NULL, `sessionID` = NULL;
UPDATE `s_core_payment_data` SET `account_holder` = LEFT(MD5(CONCAT(@common_hash_secret, `account_holder`)), LENGTH(`account_holder`)), `account_number` = LEFT(MD5(CONCAT(@common_hash_secret, `account_number`)), LENGTH(`account_number`)), `bank_code` = LEFT(MD5(CONCAT(@common_hash_secret, `bank_code`)), LENGTH(`bank_code`)), `bic` = LEFT(MD5(CONCAT(@common_hash_secret, `bic`)), LENGTH(`bic`)), `iban` = LEFT(MD5(CONCAT(@common_hash_secret, `iban`)), LENGTH(`iban`));
UPDATE `s_core_payment_instance` SET `firstname` = LEFT(MD5(CONCAT(@common_hash_secret, `firstname`)), LENGTH(`firstname`)), `lastname` = LEFT(MD5(CONCAT(@common_hash_secret, `lastname`)), LENGTH(`lastname`)), `address` = LEFT(MD5(CONCAT(@common_hash_secret, `address`)), LENGTH(`address`)), `account_holder` = LEFT(MD5(CONCAT(@common_hash_secret, `account_holder`)), LENGTH(`account_holder`)), `account_number` = LEFT(MD5(CONCAT(@common_hash_secret, `account_number`)), LENGTH(`account_number`)), `bank_code` = LEFT(MD5(CONCAT(@common_hash_secret, `bank_code`)), LENGTH(`bank_code`)), `bic` = LEFT(MD5(CONCAT(@common_hash_secret, `bic`)), LENGTH(`bic`)), `iban` = LEFT(MD5(CONCAT(@common_hash_secret, `iban`)), LENGTH(`iban`));
UPDATE `s_core_optin` SET `hash` = MD5(CONCAT(@common_hash_secret, `hash`)), `data` = '';
UPDATE `s_crontab` SET `data` = '';
UPDATE `s_emarketing_partner` SET `idcode` = LEFT(MD5(CONCAT(@common_hash_secret, `idcode`)), LENGTH(`idcode`)), `company` = LEFT(MD5(CONCAT(@common_hash_secret, `company`)), LENGTH(`company`)), `contact` = LEFT(MD5(CONCAT(@common_hash_secret, `contact`)), LENGTH(`contact`)), `street` = LEFT(MD5(CONCAT(@common_hash_secret, `street`)), LENGTH(`street`)), `zipcode` = LEFT(MD5(CONCAT(@common_hash_secret, `zipcode`)), LENGTH(`zipcode`)), `city` = LEFT(MD5(CONCAT(@common_hash_secret, `city`)), LENGTH(`city`)), `country` = LEFT(MD5(CONCAT(@common_hash_secret, `country`)), LENGTH(`country`)), `email` = '', `web` = '', `profil` = '', `phone` = ROUND(RAND()*1000000), `fax` = ROUND(RAND()*1000000);
UPDATE `s_emarketing_vouchers` SET `vouchercode` = LEFT(MD5(CONCAT(@common_hash_secret, `vouchercode`)), LENGTH(`vouchercode`));
UPDATE `s_emarketing_voucher_codes` SET `code` = LEFT(MD5(CONCAT(@common_hash_secret, `code`)), LENGTH(`code`));
UPDATE `s_emarketing_tellafriend` SET `recipient` = LEFT(MD5(CONCAT(@common_hash_secret, `recipient`)), LENGTH(`recipient`));
UPDATE `s_statistics_currentusers` SET `remoteaddr` = INET_NTOA(RAND()*1000000000);
UPDATE `s_statistics_pool` SET `remoteaddr` = INET_NTOA(RAND()*1000000000);
UPDATE `s_statistics_referer` SET `referer` = '';
UPDATE `s_user` SET `password` = MD5(CONCAT(@common_hash_secret, `password`)), `firstname` = LEFT(MD5(CONCAT(@common_hash_secret, `firstname`)), LENGTH(`firstname`)), `lastname` = LEFT(MD5(CONCAT(@common_hash_secret, `lastname`)), LENGTH(`lastname`)), `email` = CONCAT(LEFT(MD5(CONCAT(@common_hash_secret, `email`)), 12), '@localhost'), `sessionID` = NULL, `login_token` = NULL, `confirmationkey` = '', `referer` = '', `birthday` = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL FLOOR(18*365 + RAND() * 81*365) DAY), GET_FORMAT(DATE,'ISO'));
UPDATE `s_user_addresses` SET `company` = LEFT(MD5(CONCAT(@common_hash_secret, `company`)), LENGTH(`company`)), `department` = LEFT(MD5(CONCAT(@common_hash_secret, `department`)), LENGTH(`department`)), `firstname` = LEFT(MD5(CONCAT(@common_hash_secret, `firstname`)), LENGTH(`firstname`)), `lastname` = LEFT(MD5(CONCAT(@common_hash_secret, `lastname`)), LENGTH(`lastname`)), `street` = LEFT(MD5(CONCAT(@common_hash_secret, `street`)), LENGTH(`street`)), `zipcode` = LEFT(MD5(CONCAT(@common_hash_secret, `zipcode`)), LENGTH(`zipcode`)), `city` = LEFT(MD5(CONCAT(@common_hash_secret, `city`)), LENGTH(`city`)), `additional_address_line1` = '', `additional_address_line2` = '', `phone` = ROUND(RAND()*1000000), `ustid` = CONCAT('DE', LPAD(FLOOR(1 + (RAND() * 999999998)), 9, '0'));
UPDATE `s_user_addresses_attributes` SET `text1` = NULL, `text2` = NULL, `text3` = NULL, `text4` = NULL, `text5` = NULL, `text6` = NULL;
UPDATE `s_user_billingaddress` SET `company` = LEFT(MD5(CONCAT(@common_hash_secret, `company`)), LENGTH(`company`)), `department` = LEFT(MD5(CONCAT(@common_hash_secret, `department`)), LENGTH(`department`)), `firstname` = LEFT(MD5(CONCAT(@common_hash_secret, `firstname`)), LENGTH(`firstname`)), `lastname` = LEFT(MD5(CONCAT(@common_hash_secret, `lastname`)), LENGTH(`lastname`)), `street` = LEFT(MD5(CONCAT(@common_hash_secret, `street`)), LENGTH(`street`)), `zipcode` = LEFT(MD5(CONCAT(@common_hash_secret, `zipcode`)), LENGTH(`zipcode`)), `city` = LEFT(MD5(CONCAT(@common_hash_secret, `city`)), LENGTH(`city`)), `additional_address_line1` = '', `additional_address_line2` = '', `phone` = ROUND(RAND()*1000000), `ustid` = CONCAT('DE', LPAD(FLOOR(1 + (RAND() * 999999998)), 9, '0'));
UPDATE `s_user_billingaddress_attributes` SET `text1` = NULL, `text2` = NULL, `text3` = NULL, `text4` = NULL, `text5` = NULL, `text6` = NULL;
UPDATE `s_user_shippingaddress` SET `company` = LEFT(MD5(CONCAT(@common_hash_secret, `company`)), LENGTH(`company`)), `department` = LEFT(MD5(CONCAT(@common_hash_secret, `department`)), LENGTH(`department`)), `firstname` = LEFT(MD5(CONCAT(@common_hash_secret, `firstname`)), LENGTH(`firstname`)), `lastname` = LEFT(MD5(CONCAT(@common_hash_secret, `lastname`)), LENGTH(`lastname`)), `street` = LEFT(MD5(CONCAT(@common_hash_secret, `street`)), LENGTH(`street`)), `zipcode` = LEFT(MD5(CONCAT(@common_hash_secret, `zipcode`)), LENGTH(`zipcode`)), `city` = LEFT(MD5(CONCAT(@common_hash_secret, `city`)), LENGTH(`city`)), `additional_address_line1` = '', `additional_address_line2` = '';
UPDATE `s_user_shippingaddress_attributes` SET `text1` = NULL, `text2` = NULL, `text3` = NULL, `text4` = NULL, `text5` = NULL, `text6` = NULL;
UPDATE `s_order` SET `transactionID` = '', `customercomment` = '', `internalcomment` = '', `trackingcode` = '', `referer` = '', `remote_addr` = INET_NTOA(RAND()*1000000000);
UPDATE `s_order_billingaddress` SET `company` = LEFT(MD5(CONCAT(@common_hash_secret, `company`)), LENGTH(`company`)), `department` = LEFT(MD5(CONCAT(@common_hash_secret, `department`)), LENGTH(`department`)), `firstname` = LEFT(MD5(CONCAT(@common_hash_secret, `firstname`)), LENGTH(`firstname`)), `lastname` = LEFT(MD5(CONCAT(@common_hash_secret, `lastname`)), LENGTH(`lastname`)), `street` = LEFT(MD5(CONCAT(@common_hash_secret, `street`)), LENGTH(`street`)), `zipcode` = LEFT(MD5(CONCAT(@common_hash_secret, `zipcode`)), LENGTH(`zipcode`)), `city` = LEFT(MD5(CONCAT(@common_hash_secret, `city`)), LENGTH(`city`)), `additional_address_line1` = '', `additional_address_line2` = '', `phone` = ROUND(RAND()*1000000), `ustid` = CONCAT('DE', LPAD(FLOOR(1 + (RAND() * 999999998)), 9, '0'));
UPDATE `s_order_billingaddress_attributes` SET `text1` = NULL, `text2` = NULL, `text3` = NULL, `text4` = NULL, `text5` = NULL, `text6` = NULL;
UPDATE `s_order_shippingaddress` SET `company` = LEFT(MD5(CONCAT(@common_hash_secret, `company`)), LENGTH(`company`)), `department` = LEFT(MD5(CONCAT(@common_hash_secret, `department`)), LENGTH(`department`)), `firstname` = LEFT(MD5(CONCAT(@common_hash_secret, `firstname`)), LENGTH(`firstname`)), `lastname` = LEFT(MD5(CONCAT(@common_hash_secret, `lastname`)), LENGTH(`lastname`)), `street` = LEFT(MD5(CONCAT(@common_hash_secret, `street`)), LENGTH(`street`)), `zipcode` = LEFT(MD5(CONCAT(@common_hash_secret, `zipcode`)), LENGTH(`zipcode`)), `city` = LEFT(MD5(CONCAT(@common_hash_secret, `city`)), LENGTH(`city`)), `additional_address_line1` = '', `additional_address_line2` = '';
UPDATE `s_order_shippingaddress_attributes` SET `text1` = NULL, `text2` = NULL, `text3` = NULL, `text4` = NULL, `text5` = NULL, `text6` = NULL;
UPDATE `s_plugin_widgets_notes` SET `notes` = '';
SET @random_phone = CONCAT("UPDATE s_order_shippingaddress SET phone = ROUND(RAND()*100000)"); SELECT IF(@shopware_schema_version >= 951, @random_phone, "SELECT 1") INTO @phone_update; PREPARE phone_update FROM @phone_update; EXECUTE phone_update; DEALLOCATE PREPARE phone_update;
SET FOREIGN_KEY_CHECKS=1;
SET @disable_trigger = NULL;

