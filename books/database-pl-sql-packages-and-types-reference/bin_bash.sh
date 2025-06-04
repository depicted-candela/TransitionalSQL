#!/bin/bash

# PDFTK commands to extract chapters based on metadata.txt

# Input PDF file
input_pdf="database-pl-sql-packages-and-types-reference.pdf"

# 00a_contents.pdf
# BookmarkTitle: Contents, BookmarkLevel: 1, BookmarkPageNumber: 3
# Next L1: Preface, Page: 150
pdftk "${input_pdf}" cat 3-149 output 00a_contents.pdf

# 00c_preface.pdf
# BookmarkTitle: Preface, BookmarkLevel: 1, BookmarkPageNumber: 150
# Next L1: Changes in This Release..., Page: 153
pdftk "${input_pdf}" cat 150-152 output 00c_preface.pdf

# 00d_changes_in_this_release.pdf
# BookmarkTitle: Changes in This Release for Oracle Database PL/SQL Packages and Types Reference, BookmarkLevel: 1, BookmarkPageNumber: 153
# Next L1: 1 Introduction..., Page: 161
pdftk "${input_pdf}" cat 153-160 output 00d_changes_in_this_release.pdf

# ch01_introduction_to_oracle_supplied_pl_sql_packages_and_types.pdf
# BookmarkTitle: 1 Introduction to Oracle Supplied PL/SQL Packages & Types, BookmarkLevel: 1, BookmarkPageNumber: 161
# Next L1: 2 Oracle Application Express..., Page: 182
pdftk "${input_pdf}" cat 161-181 output ch01_introduction_to_oracle_supplied_pl_sql_packages_and_types.pdf

# ch02_oracle_application_express_packages_apex_application_through_apex_zip.pdf
# BookmarkTitle: 2 Oracle Application Express Packages APEX_APPLICATION Through APEX_ZIP, BookmarkLevel: 1, BookmarkPageNumber: 182
# Next L1: 3 CTX_ADM, Page: 183
pdftk "${input_pdf}" cat 182 output ch02_oracle_application_express_packages_apex_application_through_apex_zip.pdf

# ch03_ctx_adm.pdf
# BookmarkTitle: 3 CTX_ADM, BookmarkLevel: 1, BookmarkPageNumber: 183
# Next L1: 4 CTX_ANL, Page: 184
pdftk "${input_pdf}" cat 183 output ch03_ctx_adm.pdf

# ch04_ctx_anl.pdf
# BookmarkTitle: 4 CTX_ANL, BookmarkLevel: 1, BookmarkPageNumber: 184
# Next L1: 5 CTX_DDL, Page: 192
pdftk "${input_pdf}" cat 184-191 output ch04_ctx_anl.pdf

# ch05_ctx_ddl.pdf
# BookmarkTitle: 5 CTX_DDL, BookmarkLevel: 1, BookmarkPageNumber: 192
# Next L1: 6 CTX_CLS, Page: 193
pdftk "${input_pdf}" cat 192 output ch05_ctx_ddl.pdf

# ch06_ctx_cls.pdf
# BookmarkTitle: 6 CTX_CLS, BookmarkLevel: 1, BookmarkPageNumber: 193
# Next L1: 7 CTX_DOC, Page: 194
pdftk "${input_pdf}" cat 193 output ch06_ctx_cls.pdf

# ch07_ctx_doc.pdf
# BookmarkTitle: 7 CTX_DOC, BookmarkLevel: 1, BookmarkPageNumber: 194
# Next L1: 8 CTX_ENTITY, Page: 195
pdftk "${input_pdf}" cat 194 output ch07_ctx_doc.pdf

# ch08_ctx_entity.pdf
# BookmarkTitle: 8 CTX_ENTITY, BookmarkLevel: 1, BookmarkPageNumber: 195
# Next L1: 9 CTX_OUTPUT, Page: 196
pdftk "${input_pdf}" cat 195 output ch08_ctx_entity.pdf

# ch09_ctx_output.pdf
# BookmarkTitle: 9 CTX_OUTPUT, BookmarkLevel: 1, BookmarkPageNumber: 196
# Next L1: 10 DBMS_SAGA_ADM, Page: 197
pdftk "${input_pdf}" cat 196 output ch09_ctx_output.pdf

# ch10_dbms_saga_adm.pdf
# BookmarkTitle: 10 DBMS_SAGA_ADM, BookmarkLevel: 1, BookmarkPageNumber: 197
# Next L1: 11 CTX_QUERY, Page: 204
pdftk "${input_pdf}" cat 197-203 output ch10_dbms_saga_adm.pdf

# ch11_ctx_query.pdf
# BookmarkTitle: 11 CTX_QUERY, BookmarkLevel: 1, BookmarkPageNumber: 204
# Next L1: 12 CTX_REPORT, Page: 205
pdftk "${input_pdf}" cat 204 output ch11_ctx_query.pdf

# ch12_ctx_report.pdf
# BookmarkTitle: 12 CTX_REPORT, BookmarkLevel: 1, BookmarkPageNumber: 205
# Next L1: 13 CTX_THES, Page: 206
pdftk "${input_pdf}" cat 205 output ch12_ctx_report.pdf

# ch13_ctx_thes.pdf
# BookmarkTitle: 13 CTX_THES, BookmarkLevel: 1, BookmarkPageNumber: 206
# Next L1: 14 CTX_ULEXER, Page: 207
pdftk "${input_pdf}" cat 206 output ch13_ctx_thes.pdf

# ch14_ctx_ulexer.pdf
# BookmarkTitle: 14 CTX_ULEXER, BookmarkLevel: 1, BookmarkPageNumber: 207
# Next L1: 15 DBMS_ACTIVITY, Page: 208
pdftk "${input_pdf}" cat 207 output ch14_ctx_ulexer.pdf

# ch15_dbms_activity.pdf
# BookmarkTitle: 15 DBMS_ACTIVITY, BookmarkLevel: 1, BookmarkPageNumber: 208
# Next L1: 16 DBMS_ADDM, Page: 213
pdftk "${input_pdf}" cat 208-212 output ch15_dbms_activity.pdf

# ch16_dbms_addm.pdf
# BookmarkTitle: 16 DBMS_ADDM, BookmarkLevel: 1, BookmarkPageNumber: 213
# Next L1: 17 DBMS_ADVANCED_REWRITE, Page: 234
pdftk "${input_pdf}" cat 213-233 output ch16_dbms_addm.pdf

# ch17_dbms_advanced_rewrite.pdf
# BookmarkTitle: 17 DBMS_ADVANCED_REWRITE, BookmarkLevel: 1, BookmarkPageNumber: 234
# Next L1: 18 DBMS_ADVISOR, Page: 240
pdftk "${input_pdf}" cat 234-239 output ch17_dbms_advanced_rewrite.pdf

# ch18_dbms_advisor.pdf
# BookmarkTitle: 18 DBMS_ADVISOR, BookmarkLevel: 1, BookmarkPageNumber: 240
# Next L1: 19 DBMS_AUTOIM, Page: 306
pdftk "${input_pdf}" cat 240-305 output ch18_dbms_advisor.pdf

# ch19_dbms_autoim.pdf
# BookmarkTitle: 19 DBMS_AUTOIM, BookmarkLevel: 1, BookmarkPageNumber: 306
# Next L1: 20 DBMS_ALERT, Page: 309
pdftk "${input_pdf}" cat 306-308 output ch19_dbms_autoim.pdf

# ch20_dbms_alert.pdf
# BookmarkTitle: 20 DBMS_ALERT, BookmarkLevel: 1, BookmarkPageNumber: 309
# Next L1: 21 DBMS_APP_CONT, Page: 317
pdftk "${input_pdf}" cat 309-316 output ch20_dbms_alert.pdf

# ch21_dbms_app_cont.pdf
# BookmarkTitle: 21 DBMS_APP_CONT, BookmarkLevel: 1, BookmarkPageNumber: 317
# Next L1: 22 DBMS_APP_CONT_ADMIN, Page: 322
pdftk "${input_pdf}" cat 317-321 output ch21_dbms_app_cont.pdf

# ch22_dbms_app_cont_admin.pdf
# BookmarkTitle: 22 DBMS_APP_CONT_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 322
# Next L1: 23 DBMS_APP_CONT_REPORT, Page: 345
pdftk "${input_pdf}" cat 322-344 output ch22_dbms_app_cont_admin.pdf

# ch23_dbms_app_cont_report.pdf
# BookmarkTitle: 23 DBMS_APP_CONT_REPORT, BookmarkLevel: 1, BookmarkPageNumber: 345
# Next L1: 24 DBMS_APPLICATION_INFO, Page: 348
pdftk "${input_pdf}" cat 345-347 output ch23_dbms_app_cont_report.pdf

# ch24_dbms_application_info.pdf
# BookmarkTitle: 24 DBMS_APPLICATION_INFO, BookmarkLevel: 1, BookmarkPageNumber: 348
# Next L1: 25 DBMS_APPLY_ADM, Page: 355
pdftk "${input_pdf}" cat 348-354 output ch24_dbms_application_info.pdf

# ch25_dbms_apply_adm.pdf
# BookmarkTitle: 25 DBMS_APPLY_ADM, BookmarkLevel: 1, BookmarkPageNumber: 355
# Next L1: 26 DBMS_AQ, Page: 437
pdftk "${input_pdf}" cat 355-436 output ch25_dbms_apply_adm.pdf

# ch26_dbms_aq.pdf
# BookmarkTitle: 26 DBMS_AQ, BookmarkLevel: 1, BookmarkPageNumber: 437
# Next L1: 27 DBMS_AQADM, Page: 453
pdftk "${input_pdf}" cat 437-452 output ch26_dbms_aq.pdf

# ch27_dbms_aqadm.pdf
# BookmarkTitle: 27 DBMS_AQADM, BookmarkLevel: 1, BookmarkPageNumber: 453
# Next L1: 28 DBMS_AQELM, Page: 508
pdftk "${input_pdf}" cat 453-507 output ch27_dbms_aqadm.pdf

# ch28_dbms_aqelm.pdf
# BookmarkTitle: 28 DBMS_AQELM, BookmarkLevel: 1, BookmarkPageNumber: 508
# Next L1: 29 DBMS_AQIN, Page: 511
pdftk "${input_pdf}" cat 508-510 output ch28_dbms_aqelm.pdf

# ch29_dbms_aqin.pdf
# BookmarkTitle: 29 DBMS_AQIN, BookmarkLevel: 1, BookmarkPageNumber: 511
# Next L1: 30 DBMS_AQMIGTOOL, Page: 512
pdftk "${input_pdf}" cat 511 output ch29_dbms_aqin.pdf

# ch30_dbms_aqmigtool.pdf
# BookmarkTitle: 30 DBMS_AQMIGTOOL, BookmarkLevel: 1, BookmarkPageNumber: 512
# Next L1: 31 DBMS_ASSERT, Page: 526
pdftk "${input_pdf}" cat 512-525 output ch30_dbms_aqmigtool.pdf

# ch31_dbms_assert.pdf
# BookmarkTitle: 31 DBMS_ASSERT, BookmarkLevel: 1, BookmarkPageNumber: 526
# Next L1: 32 DBMS_AUDIT_MGMT, Page: 532
pdftk "${input_pdf}" cat 526-531 output ch31_dbms_assert.pdf

# ch32_dbms_audit_mgmt.pdf
# BookmarkTitle: 32 DBMS_AUDIT_MGMT, BookmarkLevel: 1, BookmarkPageNumber: 532
# Next L1: 33 DBMS_AUDIT_UTIL, Page: 565
pdftk "${input_pdf}" cat 532-564 output ch32_dbms_audit_mgmt.pdf

# ch33_dbms_audit_util.pdf
# BookmarkTitle: 33 DBMS_AUDIT_UTIL, BookmarkLevel: 1, BookmarkPageNumber: 565
# Next L1: 34 DBMS_AUTO_CLUSTERING, Page: 570
pdftk "${input_pdf}" cat 565-569 output ch33_dbms_audit_util.pdf

# ch34_dbms_auto_clustering.pdf
# BookmarkTitle: 34 DBMS_AUTO_CLUSTERING, BookmarkLevel: 1, BookmarkPageNumber: 570
# Next L1: 35 DBMS_AUTO_SQLTUNE, Page: 579
pdftk "${input_pdf}" cat 570-578 output ch34_dbms_auto_clustering.pdf

# ch35_dbms_auto_sqltune.pdf
# BookmarkTitle: 35 DBMS_AUTO_SQLTUNE, BookmarkLevel: 1, BookmarkPageNumber: 579
# Next L1: 36 DBMS_AUTO_INDEX, Page: 584
pdftk "${input_pdf}" cat 579-583 output ch35_dbms_auto_sqltune.pdf

# ch36_dbms_auto_index.pdf
# BookmarkTitle: 36 DBMS_AUTO_INDEX, BookmarkLevel: 1, BookmarkPageNumber: 584
# Next L1: 37 DBMS_AUTO_MV, Page: 597
pdftk "${input_pdf}" cat 584-596 output ch36_dbms_auto_index.pdf

# ch37_dbms_auto_mv.pdf
# BookmarkTitle: 37 DBMS_AUTO_MV, BookmarkLevel: 1, BookmarkPageNumber: 597
# Next L1: 38 DBMS_AUTO_REPORT, Page: 606
pdftk "${input_pdf}" cat 597-605 output ch37_dbms_auto_mv.pdf

# ch38_dbms_auto_report.pdf
# BookmarkTitle: 38 DBMS_AUTO_REPORT, BookmarkLevel: 1, BookmarkPageNumber: 606
# Next L1: 39 DBMS_AUTO_TASK_ADMIN, Page: 611
pdftk "${input_pdf}" cat 606-610 output ch38_dbms_auto_report.pdf

# ch39_dbms_auto_task_admin.pdf
# BookmarkTitle: 39 DBMS_AUTO_TASK_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 611
# Next L1: 40 DBMS_AUTO_ZONEMAP, Page: 618
pdftk "${input_pdf}" cat 611-617 output ch39_dbms_auto_task_admin.pdf

# ch40_dbms_auto_zonemap.pdf
# BookmarkTitle: 40 DBMS_AUTO_ZONEMAP, BookmarkLevel: 1, BookmarkPageNumber: 618
# Next L1: 41 DBMS_AVTUNE, Page: 622
pdftk "${input_pdf}" cat 618-621 output ch40_dbms_auto_zonemap.pdf

# ch41_dbms_avtune.pdf
# BookmarkTitle: 41 DBMS_AVTUNE, BookmarkLevel: 1, BookmarkPageNumber: 622
# Next L1: 42 DBMS_AW_STATS, Page: 630
pdftk "${input_pdf}" cat 622-629 output ch41_dbms_avtune.pdf

# ch42_dbms_aw_stats.pdf
# BookmarkTitle: 42 DBMS_AW_STATS, BookmarkLevel: 1, BookmarkPageNumber: 630
# Next L1: 43 DBMS_BLOCKCHAIN_TABLE, Page: 634
pdftk "${input_pdf}" cat 630-633 output ch42_dbms_aw_stats.pdf

# ch43_dbms_blockchain_table.pdf
# BookmarkTitle: 43 DBMS_BLOCKCHAIN_TABLE, BookmarkLevel: 1, BookmarkPageNumber: 634
# Next L1: 44 DBMS_BLOCKER_RESOLVER, Page: 661
pdftk "${input_pdf}" cat 634-660 output ch43_dbms_blockchain_table.pdf

# ch44_dbms_blocker_resolver.pdf
# BookmarkTitle: 44 DBMS_BLOCKER_RESOLVER, BookmarkLevel: 1, BookmarkPageNumber: 661
# Next L1: 45 DBMS_CAPTURE_ADM, Page: 664
pdftk "${input_pdf}" cat 661-663 output ch44_dbms_blocker_resolver.pdf

# ch45_dbms_capture_adm.pdf
# BookmarkTitle: 45 DBMS_CAPTURE_ADM, BookmarkLevel: 1, BookmarkPageNumber: 664
# Next L1: 46 DBMS_CACHEUTIL, Page: 711
pdftk "${input_pdf}" cat 664-710 output ch45_dbms_capture_adm.pdf

# ch46_dbms_cacheutil.pdf
# BookmarkTitle: 46 DBMS_CACHEUTIL, BookmarkLevel: 1, BookmarkPageNumber: 711
# Next L1: 47 DBMS_CLOUD, Page: 719
pdftk "${input_pdf}" cat 711-718 output ch46_dbms_cacheutil.pdf

# ch47_dbms_cloud.pdf
# BookmarkTitle: 47 DBMS_CLOUD, BookmarkLevel: 1, BookmarkPageNumber: 719
# Next L1: 48 DBMS_CLOUD_AI, Page: 826
pdftk "${input_pdf}" cat 719-825 output ch47_dbms_cloud.pdf

# ch48_dbms_cloud_ai.pdf
# BookmarkTitle: 48 DBMS_CLOUD_AI, BookmarkLevel: 1, BookmarkPageNumber: 826
# Next L1: 49 DBMS_CLOUD_NOTIFICATION, Page: 841
pdftk "${input_pdf}" cat 826-840 output ch48_dbms_cloud_ai.pdf

# ch49_dbms_cloud_notification.pdf
# BookmarkTitle: 49 DBMS_CLOUD_NOTIFICATION, BookmarkLevel: 1, BookmarkPageNumber: 841
# Next L1: 50 DBMS_CLOUD_PIPELINE, Page: 849
pdftk "${input_pdf}" cat 841-848 output ch49_dbms_cloud_notification.pdf

# ch50_dbms_cloud_pipeline.pdf
# BookmarkTitle: 50 DBMS_CLOUD_PIPELINE, BookmarkLevel: 1, BookmarkPageNumber: 849
# Next L1: 51 DBMS_CLOUD_REPO, Page: 857
pdftk "${input_pdf}" cat 849-856 output ch50_dbms_cloud_pipeline.pdf

# ch51_dbms_cloud_repo.pdf
# BookmarkTitle: 51 DBMS_CLOUD_REPO, BookmarkLevel: 1, BookmarkPageNumber: 857
# Next L1: 52 DBMS_COMPARISON, Page: 879
pdftk "${input_pdf}" cat 857-878 output ch51_dbms_cloud_repo.pdf

# ch52_dbms_comparison.pdf
# BookmarkTitle: 52 DBMS_COMPARISON, BookmarkLevel: 1, BookmarkPageNumber: 879
# Next L1: 53 DBMS_COMPRESSION, Page: 898
pdftk "${input_pdf}" cat 879-897 output ch52_dbms_comparison.pdf

# ch53_dbms_compression.pdf
# BookmarkTitle: 53 DBMS_COMPRESSION, BookmarkLevel: 1, BookmarkPageNumber: 898
# Next L1: 54 DBMS_CONNECTION_POOL, Page: 911
pdftk "${input_pdf}" cat 898-910 output ch53_dbms_compression.pdf

# ch54_dbms_connection_pool.pdf
# BookmarkTitle: 54 DBMS_CONNECTION_POOL, BookmarkLevel: 1, BookmarkPageNumber: 911
# Next L1: 55 DBMS_CQ_NOTIFICATION, Page: 921
pdftk "${input_pdf}" cat 911-920 output ch54_dbms_connection_pool.pdf

# ch55_dbms_cq_notification.pdf
# BookmarkTitle: 55 DBMS_CQ_NOTIFICATION, BookmarkLevel: 1, BookmarkPageNumber: 921
# Next L1: 56 DBMS_CREDENTIAL, Page: 940
pdftk "${input_pdf}" cat 921-939 output ch55_dbms_cq_notification.pdf

# ch56_dbms_credential.pdf
# BookmarkTitle: 56 DBMS_CREDENTIAL, BookmarkLevel: 1, BookmarkPageNumber: 940
# Next L1: 57 DBMS_CRYPTO, Page: 948
pdftk "${input_pdf}" cat 940-947 output ch56_dbms_credential.pdf

# ch57_dbms_crypto.pdf
# BookmarkTitle: 57 DBMS_CRYPTO, BookmarkLevel: 1, BookmarkPageNumber: 948
# Next L1: 58 DBMS_CSX_ADMIN, Page: 978
pdftk "${input_pdf}" cat 948-977 output ch57_dbms_crypto.pdf

# ch58_dbms_csx_admin.pdf
# BookmarkTitle: 58 DBMS_CSX_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 978
# Next L1: 59 DBMS_CUBE, Page: 982
pdftk "${input_pdf}" cat 978-981 output ch58_dbms_csx_admin.pdf

# ch59_dbms_cube.pdf
# BookmarkTitle: 59 DBMS_CUBE, BookmarkLevel: 1, BookmarkPageNumber: 982
# Next L1: 60 DBMS_CUBE_ADVISE, Page: 1031
pdftk "${input_pdf}" cat 982-1030 output ch59_dbms_cube.pdf

# ch60_dbms_cube_advise.pdf
# BookmarkTitle: 60 DBMS_CUBE_ADVISE, BookmarkLevel: 1, BookmarkPageNumber: 1031
# Next L1: 61 DBMS_CUBE_LOG, Page: 1037
pdftk "${input_pdf}" cat 1031-1036 output ch60_dbms_cube_advise.pdf

# ch61_dbms_cube_log.pdf
# BookmarkTitle: 61 DBMS_CUBE_LOG, BookmarkLevel: 1, BookmarkPageNumber: 1037
# Next L1: 62 DBMS_DATA_MINING, Page: 1061
pdftk "${input_pdf}" cat 1037-1060 output ch61_dbms_cube_log.pdf

# ch62_dbms_data_mining.pdf
# BookmarkTitle: 62 DBMS_DATA_MINING, BookmarkLevel: 1, BookmarkPageNumber: 1061
# Next L1: 63 DBMS_DATA_MINING_TRANSFORM, Page: 1258
pdftk "${input_pdf}" cat 1061-1257 output ch62_dbms_data_mining.pdf

# ch63_dbms_data_mining_transform.pdf
# BookmarkTitle: 63 DBMS_DATA_MINING_TRANSFORM, BookmarkLevel: 1, BookmarkPageNumber: 1258
# Next L1: 64 DBMS_DATAPUMP, Page: 1358
pdftk "${input_pdf}" cat 1258-1357 output ch63_dbms_data_mining_transform.pdf

# ch64_dbms_datapump.pdf
# BookmarkTitle: 64 DBMS_DATAPUMP, BookmarkLevel: 1, BookmarkPageNumber: 1358
# Next L1: 65 DBMS_DB_VERSION, Page: 1418
pdftk "${input_pdf}" cat 1358-1417 output ch64_dbms_datapump.pdf

# ch65_dbms_db_version.pdf
# BookmarkTitle: 65 DBMS_DB_VERSION, BookmarkLevel: 1, BookmarkPageNumber: 1418
# Next L1: 66 DBMS_DBCOMP, Page: 1421
pdftk "${input_pdf}" cat 1418-1420 output ch65_dbms_db_version.pdf

# ch66_dbms_dbcomp.pdf
# BookmarkTitle: 66 DBMS_DBCOMP, BookmarkLevel: 1, BookmarkPageNumber: 1421
# Next L1: 67 DBMS_DBFS_CONTENT, Page: 1424
pdftk "${input_pdf}" cat 1421-1423 output ch66_dbms_dbcomp.pdf

# ch67_dbms_dbfs_content.pdf
# BookmarkTitle: 67 DBMS_DBFS_CONTENT, BookmarkLevel: 1, BookmarkPageNumber: 1424
# Next L1: 68 DBMS_DBFS_CONTENT_SPI, Page: 1485
pdftk "${input_pdf}" cat 1424-1484 output ch67_dbms_dbfs_content.pdf

# ch68_dbms_dbfs_content_spi.pdf
# BookmarkTitle: 68 DBMS_DBFS_CONTENT_SPI, BookmarkLevel: 1, BookmarkPageNumber: 1485
# Next L1: 69 DBMS_DBFS_HS, Page: 1508
pdftk "${input_pdf}" cat 1485-1507 output ch68_dbms_dbfs_content_spi.pdf

# ch69_dbms_dbfs_hs.pdf
# BookmarkTitle: 69 DBMS_DBFS_HS, BookmarkLevel: 1, BookmarkPageNumber: 1508
# Next L1: 70 DBMS_DBFS_SFS, Page: 1525
pdftk "${input_pdf}" cat 1508-1524 output ch69_dbms_dbfs_hs.pdf

# ch70_dbms_dbfs_sfs.pdf
# BookmarkTitle: 70 DBMS_DBFS_SFS, BookmarkLevel: 1, BookmarkPageNumber: 1525
# Next L1: 71 DBMS_DDL, Page: 1531
pdftk "${input_pdf}" cat 1525-1530 output ch70_dbms_dbfs_sfs.pdf

# ch71_dbms_ddl.pdf
# BookmarkTitle: 71 DBMS_DDL, BookmarkLevel: 1, BookmarkPageNumber: 1531
# Next L1: 72 DBMS_DEBUG, Page: 1541
pdftk "${input_pdf}" cat 1531-1540 output ch71_dbms_ddl.pdf

# ch72_dbms_debug.pdf
# BookmarkTitle: 72 DBMS_DEBUG, BookmarkLevel: 1, BookmarkPageNumber: 1541
# Next L1: 73 DBMS_DEBUG_JDWP, Page: 1579
pdftk "${input_pdf}" cat 1541-1578 output ch72_dbms_debug.pdf

# ch73_dbms_debug_jdwp.pdf
# BookmarkTitle: 73 DBMS_DEBUG_JDWP, BookmarkLevel: 1, BookmarkPageNumber: 1579
# Next L1: 74 DBMS_DEBUG_JDWP_CUSTOM, Page: 1586
pdftk "${input_pdf}" cat 1579-1585 output ch73_dbms_debug_jdwp.pdf

# ch74_dbms_debug_jdwp_custom.pdf
# BookmarkTitle: 74 DBMS_DEBUG_JDWP_CUSTOM, BookmarkLevel: 1, BookmarkPageNumber: 1586
# Next L1: 75 DBMS_DESCRIBE, Page: 1589
pdftk "${input_pdf}" cat 1586-1588 output ch74_dbms_debug_jdwp_custom.pdf

# ch75_dbms_describe.pdf
# BookmarkTitle: 75 DBMS_DESCRIBE, BookmarkLevel: 1, BookmarkPageNumber: 1589
# Next L1: 76 DBMS_DEVELOPER, Page: 1596
pdftk "${input_pdf}" cat 1589-1595 output ch75_dbms_describe.pdf

# ch76_dbms_developer.pdf
# BookmarkTitle: 76 DBMS_DEVELOPER, BookmarkLevel: 1, BookmarkPageNumber: 1596
# Next L1: 77 DBMS_DG, Page: 1666
pdftk "${input_pdf}" cat 1596-1665 output ch76_dbms_developer.pdf

# ch77_dbms_dg.pdf
# BookmarkTitle: 77 DBMS_DG, BookmarkLevel: 1, BookmarkPageNumber: 1666
# Next L1: 78 DBMS_DICTIONARY_CHECK, Page: 1669
pdftk "${input_pdf}" cat 1666-1668 output ch77_dbms_dg.pdf

# ch78_dbms_dictionary_check.pdf
# BookmarkTitle: 78 DBMS_DICTIONARY_CHECK, BookmarkLevel: 1, BookmarkPageNumber: 1669
# Next L1: 79 DBMS_DIMENSION, Page: 1681
pdftk "${input_pdf}" cat 1669-1680 output ch78_dbms_dictionary_check.pdf

# ch79_dbms_dimension.pdf
# BookmarkTitle: 79 DBMS_DIMENSION, BookmarkLevel: 1, BookmarkPageNumber: 1681
# Next L1: 80 DBMS_DISTRIBUTED_TRUST_ADMIN, Page: 1683
pdftk "${input_pdf}" cat 1681-1682 output ch79_dbms_dimension.pdf

# ch80_dbms_distributed_trust_admin.pdf
# BookmarkTitle: 80 DBMS_DISTRIBUTED_TRUST_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 1683
# Next L1: 81 DBMS_DNFS, Page: 1687
pdftk "${input_pdf}" cat 1683-1686 output ch80_dbms_distributed_trust_admin.pdf

# ch81_dbms_dnfs.pdf
# BookmarkTitle: 81 DBMS_DNFS, BookmarkLevel: 1, BookmarkPageNumber: 1687
# Next L1: 82 DBMS_DST, Page: 1690
pdftk "${input_pdf}" cat 1687-1689 output ch81_dbms_dnfs.pdf

# ch82_dbms_dst.pdf
# BookmarkTitle: 82 DBMS_DST, BookmarkLevel: 1, BookmarkPageNumber: 1690
# Next L1: 83 DBMS_EDITIONS_UTILITIES, Page: 1701
pdftk "${input_pdf}" cat 1690-1700 output ch82_dbms_dst.pdf

# ch83_dbms_editions_utilities.pdf
# BookmarkTitle: 83 DBMS_EDITIONS_UTILITIES, BookmarkLevel: 1, BookmarkPageNumber: 1701
# Next L1: 84 DBMS_EPG, Page: 1704
pdftk "${input_pdf}" cat 1701-1703 output ch83_dbms_editions_utilities.pdf

# ch84_dbms_epg.pdf
# BookmarkTitle: 84 DBMS_EPG, BookmarkLevel: 1, BookmarkPageNumber: 1704
# Next L1: 85 DBMS_ERRLOG, Page: 1719
pdftk "${input_pdf}" cat 1704-1718 output ch84_dbms_epg.pdf

# ch85_dbms_errlog.pdf
# BookmarkTitle: 85 DBMS_ERRLOG, BookmarkLevel: 1, BookmarkPageNumber: 1719
# Next L1: 86 DBMS_FGA, Page: 1722
pdftk "${input_pdf}" cat 1719-1721 output ch85_dbms_errlog.pdf

# ch86_dbms_fga.pdf
# BookmarkTitle: 86 DBMS_FGA, BookmarkLevel: 1, BookmarkPageNumber: 1722
# Next L1: 87 DBMS_FILE_TRANSFER, Page: 1729
pdftk "${input_pdf}" cat 1722-1728 output ch86_dbms_fga.pdf

# ch87_dbms_file_transfer.pdf
# BookmarkTitle: 87 DBMS_FILE_TRANSFER, BookmarkLevel: 1, BookmarkPageNumber: 1729
# Next L1: 88 DBMS_FLASHBACK, Page: 1736
pdftk "${input_pdf}" cat 1729-1735 output ch87_dbms_file_transfer.pdf

# ch88_dbms_flashback.pdf
# BookmarkTitle: 88 DBMS_FLASHBACK, BookmarkLevel: 1, BookmarkPageNumber: 1736
# Next L1: 89 DBMS_FLASHBACK_ARCHIVE, Page: 1745
pdftk "${input_pdf}" cat 1736-1744 output ch88_dbms_flashback.pdf

# ch89_dbms_flashback_archive.pdf
# BookmarkTitle: 89 DBMS_FLASHBACK_ARCHIVE, BookmarkLevel: 1, BookmarkPageNumber: 1745
# Next L1: 90 DBMS_FLASHBACK_ARCHIVE_MIGRATE, Page: 1758
pdftk "${input_pdf}" cat 1745-1757 output ch89_dbms_flashback_archive.pdf

# ch90_dbms_flashback_archive_migrate.pdf
# BookmarkTitle: 90 DBMS_FLASHBACK_ARCHIVE_MIGRATE, BookmarkLevel: 1, BookmarkPageNumber: 1758
# Next L1: 91 DBMS_FREQUENT_ITEMSET, Page: 1764
pdftk "${input_pdf}" cat 1758-1763 output ch90_dbms_flashback_archive_migrate.pdf

# ch91_dbms_frequent_itemset.pdf
# BookmarkTitle: 91 DBMS_FREQUENT_ITEMSET, BookmarkLevel: 1, BookmarkPageNumber: 1764
# Next L1: 92 DBMS_FS, Page: 1770
pdftk "${input_pdf}" cat 1764-1769 output ch91_dbms_frequent_itemset.pdf

# ch92_dbms_fs.pdf
# BookmarkTitle: 92 DBMS_FS, BookmarkLevel: 1, BookmarkPageNumber: 1770
# Next L1: 93 DBMS_GOLDENGATE_ADM, Page: 1781
pdftk "${input_pdf}" cat 1770-1780 output ch92_dbms_fs.pdf

# ch93_dbms_goldengate_adm.pdf
# BookmarkTitle: 93 DBMS_GOLDENGATE_ADM, BookmarkLevel: 1, BookmarkPageNumber: 1781
# Next L1: 94 DBMS_GOLDENGATE_AUTH, Page: 1794
pdftk "${input_pdf}" cat 1781-1793 output ch93_dbms_goldengate_adm.pdf

# ch94_dbms_goldengate_auth.pdf
# BookmarkTitle: 94 DBMS_GOLDENGATE_AUTH, BookmarkLevel: 1, BookmarkPageNumber: 1794
# Next L1: 95 DBMS_HADOOP, Page: 1800
pdftk "${input_pdf}" cat 1794-1799 output ch94_dbms_goldengate_auth.pdf

# ch95_dbms_hadoop.pdf
# BookmarkTitle: 95 DBMS_HADOOP, BookmarkLevel: 1, BookmarkPageNumber: 1800
# Next L1: 96 DBMS_HEAT_MAP, Page: 1804
pdftk "${input_pdf}" cat 1800-1803 output ch95_dbms_hadoop.pdf

# ch96_dbms_heat_map.pdf
# BookmarkTitle: 96 DBMS_HEAT_MAP, BookmarkLevel: 1, BookmarkPageNumber: 1804
# Next L1: 97 DBMS_HIERARCHY, Page: 1811
pdftk "${input_pdf}" cat 1804-1810 output ch96_dbms_heat_map.pdf

# ch97_dbms_hierarchy.pdf
# BookmarkTitle: 97 DBMS_HIERARCHY, BookmarkLevel: 1, BookmarkPageNumber: 1811
# Next L1: 98 DBMS_HM, Page: 1823
pdftk "${input_pdf}" cat 1811-1822 output ch97_dbms_hierarchy.pdf

# ch98_dbms_hm.pdf
# BookmarkTitle: 98 DBMS_HM, BookmarkLevel: 1, BookmarkPageNumber: 1823
# Next L1: 99 DBMS_HPROF, Page: 1826
pdftk "${input_pdf}" cat 1823-1825 output ch98_dbms_hm.pdf

# ch99_dbms_hprof.pdf
# BookmarkTitle: 99 DBMS_HPROF, BookmarkLevel: 1, BookmarkPageNumber: 1826
# Next L1: 100 DBMS_HS_PARALLEL, Page: 1832
pdftk "${input_pdf}" cat 1826-1831 output ch99_dbms_hprof.pdf

# ch100_dbms_hs_parallel.pdf
# BookmarkTitle: 100 DBMS_HS_PARALLEL, BookmarkLevel: 1, BookmarkPageNumber: 1832
# Next L1: 101 DBMS_HS_PASSTHROUGH, Page: 1837
pdftk "${input_pdf}" cat 1832-1836 output ch100_dbms_hs_parallel.pdf

# ch101_dbms_hs_passthrough.pdf
# BookmarkTitle: 101 DBMS_HS_PASSTHROUGH, BookmarkLevel: 1, BookmarkPageNumber: 1837
# Next L1: 102 DBMS_HYBRID_VECTOR, Page: 1851
pdftk "${input_pdf}" cat 1837-1850 output ch101_dbms_hs_passthrough.pdf

# ch102_dbms_hybrid_vector.pdf
# BookmarkTitle: 102 DBMS_HYBRID_VECTOR, BookmarkLevel: 1, BookmarkPageNumber: 1851
# Next L1: 103 DBMS_ILM, Page: 1873
pdftk "${input_pdf}" cat 1851-1872 output ch102_dbms_hybrid_vector.pdf

# ch103_dbms_ilm.pdf
# BookmarkTitle: 103 DBMS_ILM, BookmarkLevel: 1, BookmarkPageNumber: 1873
# Next L1: 104 DBMS_ILM_ADMIN, Page: 1880
pdftk "${input_pdf}" cat 1873-1879 output ch103_dbms_ilm.pdf

# ch104_dbms_ilm_admin.pdf
# BookmarkTitle: 104 DBMS_ILM_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 1880
# Next L1: 105 DBMS_IMMUTABLE_TABLE, Page: 1888
pdftk "${input_pdf}" cat 1880-1887 output ch104_dbms_ilm_admin.pdf

# ch105_dbms_immutable_table.pdf
# BookmarkTitle: 105 DBMS_IMMUTABLE_TABLE, BookmarkLevel: 1, BookmarkPageNumber: 1888
# Next L1: 106 DBMS_INMEMORY, Page: 1891
pdftk "${input_pdf}" cat 1888-1890 output ch105_dbms_immutable_table.pdf

# ch106_dbms_inmemory.pdf
# BookmarkTitle: 106 DBMS_INMEMORY, BookmarkLevel: 1, BookmarkPageNumber: 1891
# Next L1: 107 DBMS_INMEMORY_ADMIN, Page: 1896
pdftk "${input_pdf}" cat 1891-1895 output ch106_dbms_inmemory.pdf

# ch107_dbms_inmemory_admin.pdf
# BookmarkTitle: 107 DBMS_INMEMORY_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 1896
# Next L1: 108 DBMS_INMEMORY_ADVISE, Page: 1915
pdftk "${input_pdf}" cat 1896-1914 output ch107_dbms_inmemory_admin.pdf

# ch108_dbms_inmemory_advise.pdf
# BookmarkTitle: 108 DBMS_INMEMORY_ADVISE, BookmarkLevel: 1, BookmarkPageNumber: 1915
# Next L1: 109 DBMS_IOT, Page: 1920
pdftk "${input_pdf}" cat 1915-1919 output ch108_dbms_inmemory_advise.pdf

# ch109_dbms_iot.pdf
# BookmarkTitle: 109 DBMS_IOT, BookmarkLevel: 1, BookmarkPageNumber: 1920
# Next L1: 110 DBMS_JAVA, Page: 1923
pdftk "${input_pdf}" cat 1920-1922 output ch109_dbms_iot.pdf

# ch110_dbms_java.pdf
# BookmarkTitle: 110 DBMS_JAVA, BookmarkLevel: 1, BookmarkPageNumber: 1923
# Next L1: 111 DBMS_JOB, Page: 1924
pdftk "${input_pdf}" cat 1923 output ch110_dbms_java.pdf

# ch111_dbms_job.pdf
# BookmarkTitle: 111 DBMS_JOB, BookmarkLevel: 1, BookmarkPageNumber: 1924
# Next L1: 112 DBMS_JSON_DUALITY, Page: 1935
pdftk "${input_pdf}" cat 1924-1934 output ch111_dbms_job.pdf

# ch112_dbms_json_duality.pdf
# BookmarkTitle: 112 DBMS_JSON_DUALITY, BookmarkLevel: 1, BookmarkPageNumber: 1935
# Next L1: 113 DBMS_JSON, Page: 1952
pdftk "${input_pdf}" cat 1935-1951 output ch112_dbms_json_duality.pdf

# ch113_dbms_json.pdf
# BookmarkTitle: 113 DBMS_JSON, BookmarkLevel: 1, BookmarkPageNumber: 1952
# Next L1: 114 DBMS_JSON_SCHEMA, Page: 1965
pdftk "${input_pdf}" cat 1952-1964 output ch113_dbms_json.pdf

# ch114_dbms_json_schema.pdf
# BookmarkTitle: 114 DBMS_JSON_SCHEMA, BookmarkLevel: 1, BookmarkPageNumber: 1965
# Next L1: 115 DBMS_KAFKA, Page: 1970
pdftk "${input_pdf}" cat 1965-1969 output ch114_dbms_json_schema.pdf

# ch115_dbms_kafka.pdf
# BookmarkTitle: 115 DBMS_KAFKA, BookmarkLevel: 1, BookmarkPageNumber: 1970
# Next L1: 116 DBMS_KAFKA_ADM, Page: 2006
pdftk "${input_pdf}" cat 1970-2005 output ch115_dbms_kafka.pdf

# ch116_dbms_kafka_adm.pdf
# BookmarkTitle: 116 DBMS_KAFKA_ADM, BookmarkLevel: 1, BookmarkPageNumber: 2006
# Next L1: 117 DBMS_LDAP, Page: 2018
pdftk "${input_pdf}" cat 2006-2017 output ch116_dbms_kafka_adm.pdf

# ch117_dbms_ldap.pdf
# BookmarkTitle: 117 DBMS_LDAP, BookmarkLevel: 1, BookmarkPageNumber: 2018
# Next L1: 118 DBMS_LDAP_UTL, Page: 2019
pdftk "${input_pdf}" cat 2018 output ch117_dbms_ldap.pdf

# ch118_dbms_ldap_utl.pdf
# BookmarkTitle: 118 DBMS_LDAP_UTL, BookmarkLevel: 1, BookmarkPageNumber: 2019
# Next L1: 119 DBMS_LIBCACHE, Page: 2020
pdftk "${input_pdf}" cat 2019 output ch118_dbms_ldap_utl.pdf

# ch119_dbms_libcache.pdf
# BookmarkTitle: 119 DBMS_LIBCACHE, BookmarkLevel: 1, BookmarkPageNumber: 2020
# Next L1: 120 DBMS_LOB, Page: 2023
pdftk "${input_pdf}" cat 2020-2022 output ch119_dbms_libcache.pdf

# ch120_dbms_lob.pdf
# BookmarkTitle: 120 DBMS_LOB, BookmarkLevel: 1, BookmarkPageNumber: 2023
# Next L1: 121 DBMS_LOCK, Page: 2093
pdftk "${input_pdf}" cat 2023-2092 output ch120_dbms_lob.pdf

# ch121_dbms_lock.pdf
# BookmarkTitle: 121 DBMS_LOCK, BookmarkLevel: 1, BookmarkPageNumber: 2093
# Next L1: 122 DBMS_LOGMNR, Page: 2101
pdftk "${input_pdf}" cat 2093-2100 output ch121_dbms_lock.pdf

# ch122_dbms_logmnr.pdf
# BookmarkTitle: 122 DBMS_LOGMNR, BookmarkLevel: 1, BookmarkPageNumber: 2101
# Next L1: 123 DBMS_LOGSTDBY, Page: 2115
pdftk "${input_pdf}" cat 2101-2114 output ch122_dbms_logmnr.pdf

# ch123_dbms_logstdby.pdf
# BookmarkTitle: 123 DBMS_LOGSTDBY, BookmarkLevel: 1, BookmarkPageNumber: 2115
# Next L1: 124 DBMS_LOGMNR_D, Page: 2146
pdftk "${input_pdf}" cat 2115-2145 output ch123_dbms_logstdby.pdf

# ch124_dbms_logmnr_d.pdf
# BookmarkTitle: 124 DBMS_LOGMNR_D, BookmarkLevel: 1, BookmarkPageNumber: 2146
# Next L1: 125 DBMS_LOGSTDBY_CONTEXT, Page: 2151
pdftk "${input_pdf}" cat 2146-2150 output ch124_dbms_logmnr_d.pdf

# ch125_dbms_logstdby_context.pdf
# BookmarkTitle: 125 DBMS_LOGSTDBY_CONTEXT, BookmarkLevel: 1, BookmarkPageNumber: 2151
# Next L1: 126 DBMS_MEMOPTIMIZE, Page: 2155
pdftk "${input_pdf}" cat 2151-2154 output ch125_dbms_logstdby_context.pdf

# ch126_dbms_memoptimize.pdf
# BookmarkTitle: 126 DBMS_MEMOPTIMIZE, BookmarkLevel: 1, BookmarkPageNumber: 2155
# Next L1: 127 DBMS_MEMOPTIMIZE_ADMIN, Page: 2159
pdftk "${input_pdf}" cat 2155-2158 output ch126_dbms_memoptimize.pdf

# ch127_dbms_memoptimize_admin.pdf
# BookmarkTitle: 127 DBMS_MEMOPTIMIZE_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 2159
# Next L1: 128 DBMS_METADATA, Page: 2161
pdftk "${input_pdf}" cat 2159-2160 output ch127_dbms_memoptimize_admin.pdf

# ch128_dbms_metadata.pdf
# BookmarkTitle: 128 DBMS_METADATA, BookmarkLevel: 1, BookmarkPageNumber: 2161
# Next L1: 129 DBMS_METADATA_DIFF, Page: 2217
pdftk "${input_pdf}" cat 2161-2216 output ch128_dbms_metadata.pdf

# ch129_dbms_metadata_diff.pdf
# BookmarkTitle: 129 DBMS_METADATA_DIFF, BookmarkLevel: 1, BookmarkPageNumber: 2217
# Next L1: 130 DBMS_MGD_ID_UTL, Page: 2223
pdftk "${input_pdf}" cat 2217-2222 output ch129_dbms_metadata_diff.pdf

# ch130_dbms_mgd_id_utl.pdf
# BookmarkTitle: 130 DBMS_MGD_ID_UTL, BookmarkLevel: 1, BookmarkPageNumber: 2223
# Next L1: 131 DBMS_MGWADM, Page: 2248
pdftk "${input_pdf}" cat 2223-2247 output ch130_dbms_mgd_id_utl.pdf

# ch131_dbms_mgwadm.pdf
# BookmarkTitle: 131 DBMS_MGWADM, BookmarkLevel: 1, BookmarkPageNumber: 2248
# Next L1: 132 DBMS_MGWMSG, Page: 2294
pdftk "${input_pdf}" cat 2248-2293 output ch131_dbms_mgwadm.pdf

# ch132_dbms_mgwmsg.pdf
# BookmarkTitle: 132 DBMS_MGWMSG, BookmarkLevel: 1, BookmarkPageNumber: 2294
# Next L1: 133 DBMS_MLE, Page: 2321
pdftk "${input_pdf}" cat 2294-2320 output ch132_dbms_mgwmsg.pdf

# ch133_dbms_mle.pdf
# BookmarkTitle: 133 DBMS_MLE, BookmarkLevel: 1, BookmarkPageNumber: 2321
# Next L1: 134 DBMS_MONITOR, Page: 2346
pdftk "${input_pdf}" cat 2321-2345 output ch133_dbms_mle.pdf

# ch134_dbms_monitor.pdf
# BookmarkTitle: 134 DBMS_MONITOR, BookmarkLevel: 1, BookmarkPageNumber: 2346
# Next L1: 135 DBMS_MVIEW, Page: 2357
pdftk "${input_pdf}" cat 2346-2356 output ch134_dbms_monitor.pdf

# ch135_dbms_mview.pdf
# BookmarkTitle: 135 DBMS_MVIEW, BookmarkLevel: 1, BookmarkPageNumber: 2357
# Next L1: 136 DBMS_MVIEW_STATS, Page: 2374
pdftk "${input_pdf}" cat 2357-2373 output ch135_dbms_mview.pdf

# ch136_dbms_mview_stats.pdf
# BookmarkTitle: 136 DBMS_MVIEW_STATS, BookmarkLevel: 1, BookmarkPageNumber: 2374
# Next L1: 137 DBMS_NETWORK_ACL_ADMIN, Page: 2379
pdftk "${input_pdf}" cat 2374-2378 output ch136_dbms_mview_stats.pdf

# ch137_dbms_network_acl_admin.pdf
# BookmarkTitle: 137 DBMS_NETWORK_ACL_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 2379
# Next L1: 138 DBMS_NETWORK_ACL_UTILITY, Page: 2400
pdftk "${input_pdf}" cat 2379-2399 output ch137_dbms_network_acl_admin.pdf

# ch138_dbms_network_acl_utility.pdf
# BookmarkTitle: 138 DBMS_NETWORK_ACL_UTILITY, BookmarkLevel: 1, BookmarkPageNumber: 2400
# Next L1: 139 DBMS_ODCI, Page: 2406
pdftk "${input_pdf}" cat 2400-2405 output ch138_dbms_network_acl_utility.pdf

# ch139_dbms_odci.pdf
# BookmarkTitle: 139 DBMS_ODCI, BookmarkLevel: 1, BookmarkPageNumber: 2406
# Next L1: 140 DBMS_OPTIM_BUNDLE, Page: 2408
pdftk "${input_pdf}" cat 2406-2407 output ch139_dbms_odci.pdf

# ch140_dbms_optim_bundle.pdf
# BookmarkTitle: 140 DBMS_OPTIM_BUNDLE, BookmarkLevel: 1, BookmarkPageNumber: 2408
# Next L1: 141 DBMS_OUTLN, Page: 2413
pdftk "${input_pdf}" cat 2408-2412 output ch140_dbms_optim_bundle.pdf

# ch141_dbms_outln.pdf
# BookmarkTitle: 141 DBMS_OUTLN, BookmarkLevel: 1, BookmarkPageNumber: 2413
# Next L1: 142 DBMS_OUTPUT, Page: 2418
pdftk "${input_pdf}" cat 2413-2417 output ch141_dbms_outln.pdf

# ch142_dbms_output.pdf
# BookmarkTitle: 142 DBMS_OUTPUT, BookmarkLevel: 1, BookmarkPageNumber: 2418
# Next L1: 143 DBMS_PARALLEL_EXECUTE, Page: 2429
pdftk "${input_pdf}" cat 2418-2428 output ch142_dbms_output.pdf

# ch143_dbms_parallel_execute.pdf
# BookmarkTitle: 143 DBMS_PARALLEL_EXECUTE, BookmarkLevel: 1, BookmarkPageNumber: 2429
# Next L1: 144 DBMS_PART, Page: 2448
pdftk "${input_pdf}" cat 2429-2447 output ch143_dbms_parallel_execute.pdf

# ch144_dbms_part.pdf
# BookmarkTitle: 144 DBMS_PART, BookmarkLevel: 1, BookmarkPageNumber: 2448
# Next L1: 145 DBMS_PCLXUTIL, Page: 2451
pdftk "${input_pdf}" cat 2448-2450 output ch144_dbms_part.pdf

# ch145_dbms_pclxutil.pdf
# BookmarkTitle: 145 DBMS_PCLXUTIL, BookmarkLevel: 1, BookmarkPageNumber: 2451
# Next L1: 146 DBMS_PDB, Page: 2455
pdftk "${input_pdf}" cat 2451-2454 output ch145_dbms_pclxutil.pdf

# ch146_dbms_pdb.pdf
# BookmarkTitle: 146 DBMS_PDB, BookmarkLevel: 1, BookmarkPageNumber: 2455
# Next L1: 147 DBMS_PDB_ALTER_SHARING, Page: 2465
pdftk "${input_pdf}" cat 2455-2464 output ch146_dbms_pdb.pdf

# ch147_dbms_pdb_alter_sharing.pdf
# BookmarkTitle: 147 DBMS_PDB_ALTER_SHARING, BookmarkLevel: 1, BookmarkPageNumber: 2465
# Next L1: 148 DBMS_PERF, Page: 2472
pdftk "${input_pdf}" cat 2465-2471 output ch147_dbms_pdb_alter_sharing.pdf

# ch148_dbms_perf.pdf
# BookmarkTitle: 148 DBMS_PERF, BookmarkLevel: 1, BookmarkPageNumber: 2472
# Next L1: 149 DBMS_PIPE, Page: 2478
pdftk "${input_pdf}" cat 2472-2477 output ch148_dbms_perf.pdf

# ch149_dbms_pipe.pdf
# BookmarkTitle: 149 DBMS_PIPE, BookmarkLevel: 1, BookmarkPageNumber: 2478
# Next L1: 150 DBMS_PLSQL_CODE_COVERAGE, Page: 2508
pdftk "${input_pdf}" cat 2478-2507 output ch149_dbms_pipe.pdf

# ch150_dbms_plsql_code_coverage.pdf
# BookmarkTitle: 150 DBMS_PLSQL_CODE_COVERAGE, BookmarkLevel: 1, BookmarkPageNumber: 2508
# Next L1: 151 DBMS_PREDICTIVE_ANALYTICS, Page: 2513
pdftk "${input_pdf}" cat 2508-2512 output ch150_dbms_plsql_code_coverage.pdf

# ch151_dbms_predictive_analytics.pdf
# BookmarkTitle: 151 DBMS_PREDICTIVE_ANALYTICS, BookmarkLevel: 1, BookmarkPageNumber: 2513
# Next L1: 152 DBMS_PREPROCESSOR, Page: 2523
pdftk "${input_pdf}" cat 2513-2522 output ch151_dbms_predictive_analytics.pdf

# ch152_dbms_preprocessor.pdf
# BookmarkTitle: 152 DBMS_PREPROCESSOR, BookmarkLevel: 1, BookmarkPageNumber: 2523
# Next L1: 153 DBMS_PRIVILEGE_CAPTURE, Page: 2528
pdftk "${input_pdf}" cat 2523-2527 output ch152_dbms_preprocessor.pdf

# ch153_dbms_privilege_capture.pdf
# BookmarkTitle: 153 DBMS_PRIVILEGE_CAPTURE, BookmarkLevel: 1, BookmarkPageNumber: 2528
# Next L1: 154 DBMS_PROCESS, Page: 2535
pdftk "${input_pdf}" cat 2528-2534 output ch153_dbms_privilege_capture.pdf

# ch154_dbms_process.pdf
# BookmarkTitle: 154 DBMS_PROCESS, BookmarkLevel: 1, BookmarkPageNumber: 2535
# Next L1: 155 DBMS_PROFILER, Page: 2539
pdftk "${input_pdf}" cat 2535-2538 output ch154_dbms_process.pdf

# ch155_dbms_profiler.pdf
# BookmarkTitle: 155 DBMS_PROFILER, BookmarkLevel: 1, BookmarkPageNumber: 2539
# Next L1: 156 DBMS_PROPAGATION_ADM, Page: 2547
pdftk "${input_pdf}" cat 2539-2546 output ch155_dbms_profiler.pdf

# ch156_dbms_propagation_adm.pdf
# BookmarkTitle: 156 DBMS_PROPAGATION_ADM, BookmarkLevel: 1, BookmarkPageNumber: 2547
# Next L1: 157 DBMS_QOPATCH, Page: 2555
pdftk "${input_pdf}" cat 2547-2554 output ch156_dbms_propagation_adm.pdf

# ch157_dbms_qopatch.pdf
# BookmarkTitle: 157 DBMS_QOPATCH, BookmarkLevel: 1, BookmarkPageNumber: 2555
# Next L1: 158 DBMS_RANDOM, Page: 2563
pdftk "${input_pdf}" cat 2555-2562 output ch157_dbms_qopatch.pdf

# ch158_dbms_random.pdf
# BookmarkTitle: 158 DBMS_RANDOM, BookmarkLevel: 1, BookmarkPageNumber: 2563
# Next L1: 159 DBMS_REDACT, Page: 2569
pdftk "${input_pdf}" cat 2563-2568 output ch158_dbms_random.pdf

# ch159_dbms_redact.pdf
# BookmarkTitle: 159 DBMS_REDACT, BookmarkLevel: 1, BookmarkPageNumber: 2569
# Next L1: 160 DBMS_REDEFINITION, Page: 2596
pdftk "${input_pdf}" cat 2569-2595 output ch159_dbms_redact.pdf

# ch160_dbms_redefinition.pdf
# BookmarkTitle: 160 DBMS_REDEFINITION, BookmarkLevel: 1, BookmarkPageNumber: 2596
# Next L1: 161 DBMS_REFRESH, Page: 2613
pdftk "${input_pdf}" cat 2596-2612 output ch160_dbms_redefinition.pdf

# ch161_dbms_refresh.pdf
# BookmarkTitle: 161 DBMS_REFRESH, BookmarkLevel: 1, BookmarkPageNumber: 2613
# Next L1: 162 DBMS_REPAIR, Page: 2620
pdftk "${input_pdf}" cat 2613-2619 output ch161_dbms_refresh.pdf

# ch162_dbms_repair.pdf
# BookmarkTitle: 162 DBMS_REPAIR, BookmarkLevel: 1, BookmarkPageNumber: 2620
# Next L1: 163 DBMS_RESCONFIG, Page: 2631
pdftk "${input_pdf}" cat 2620-2630 output ch162_dbms_repair.pdf

# ch163_dbms_resconfig.pdf
# BookmarkTitle: 163 DBMS_RESCONFIG, BookmarkLevel: 1, BookmarkPageNumber: 2631
# Next L1: 164 DBMS_RESOURCE_MANAGER, Page: 2639
pdftk "${input_pdf}" cat 2631-2638 output ch163_dbms_resconfig.pdf

# ch164_dbms_resource_manager.pdf
# BookmarkTitle: 164 DBMS_RESOURCE_MANAGER, BookmarkLevel: 1, BookmarkPageNumber: 2639
# Next L1: 165 DBMS_RESOURCE_MANAGER_PRIVS, Page: 2679
pdftk "${input_pdf}" cat 2639-2678 output ch164_dbms_resource_manager.pdf

# ch165_dbms_resource_manager_privs.pdf
# BookmarkTitle: 165 DBMS_RESOURCE_MANAGER_PRIVS, BookmarkLevel: 1, BookmarkPageNumber: 2679
# Next L1: 166 DBMS_RESULT_CACHE, Page: 2683
pdftk "${input_pdf}" cat 2679-2682 output ch165_dbms_resource_manager_privs.pdf

# ch166_dbms_result_cache.pdf
# BookmarkTitle: 166 DBMS_RESULT_CACHE, BookmarkLevel: 1, BookmarkPageNumber: 2683
# Next L1: 167 DBMS_RESUMABLE, Page: 2694
pdftk "${input_pdf}" cat 2683-2693 output ch166_dbms_result_cache.pdf

# ch167_dbms_resumable.pdf
# BookmarkTitle: 167 DBMS_RESUMABLE, BookmarkLevel: 1, BookmarkPageNumber: 2694
# Next L1: 168 DBMS_RLS, Page: 2699
pdftk "${input_pdf}" cat 2694-2698 output ch167_dbms_resumable.pdf

# ch168_dbms_rls.pdf
# BookmarkTitle: 168 DBMS_RLS, BookmarkLevel: 1, BookmarkPageNumber: 2699
# Next L1: 169 DBMS_ROLLING, Page: 2718
pdftk "${input_pdf}" cat 2699-2717 output ch168_dbms_rls.pdf

# ch169_dbms_rolling.pdf
# BookmarkTitle: 169 DBMS_ROLLING, BookmarkLevel: 1, BookmarkPageNumber: 2718
# Next L1: 170 DBMS_ROWID, Page: 2729
pdftk "${input_pdf}" cat 2718-2728 output ch169_dbms_rolling.pdf

# ch170_dbms_rowid.pdf
# BookmarkTitle: 170 DBMS_ROWID, BookmarkLevel: 1, BookmarkPageNumber: 2729
# Next L1: 171 DBMS_RULE, Page: 2742
pdftk "${input_pdf}" cat 2729-2741 output ch170_dbms_rowid.pdf

# ch171_dbms_rule.pdf
# BookmarkTitle: 171 DBMS_RULE, BookmarkLevel: 1, BookmarkPageNumber: 2742
# Next L1: 172 DBMS_RULE_ADM, Page: 2753
pdftk "${input_pdf}" cat 2742-2752 output ch171_dbms_rule.pdf

# ch172_dbms_rule_adm.pdf
# BookmarkTitle: 172 DBMS_RULE_ADM, BookmarkLevel: 1, BookmarkPageNumber: 2753
# Next L1: 173 DBMS_SAGA, Page: 2773
pdftk "${input_pdf}" cat 2753-2772 output ch172_dbms_rule_adm.pdf

# ch173_dbms_saga.pdf
# BookmarkTitle: 173 DBMS_SAGA, BookmarkLevel: 1, BookmarkPageNumber: 2773
# Next L1: 174 DBMS_SCHEDULER, Page: 2778
pdftk "${input_pdf}" cat 2773-2777 output ch173_dbms_saga.pdf

# ch174_dbms_scheduler.pdf
# BookmarkTitle: 174 DBMS_SCHEDULER, BookmarkLevel: 1, BookmarkPageNumber: 2778
# Next L1: 175 DBMS_SEARCH, Page: 2904
pdftk "${input_pdf}" cat 2778-2903 output ch174_dbms_scheduler.pdf

# ch175_dbms_search.pdf
# BookmarkTitle: 175 DBMS_SEARCH, BookmarkLevel: 1, BookmarkPageNumber: 2904
# Next L1: 176 DBMS_SERVER_ALERT, Page: 2905
pdftk "${input_pdf}" cat 2904 output ch175_dbms_search.pdf

# ch176_dbms_server_alert.pdf
# BookmarkTitle: 176 DBMS_SERVER_ALERT, BookmarkLevel: 1, BookmarkPageNumber: 2905
# Next L1: 177 DBMS_SERVICE, Page: 2914
pdftk "${input_pdf}" cat 2905-2913 output ch176_dbms_server_alert.pdf

# ch177_dbms_service.pdf
# BookmarkTitle: 177 DBMS_SERVICE, BookmarkLevel: 1, BookmarkPageNumber: 2914
# Next L1: 178 DBMS_SESSION, Page: 2931
pdftk "${input_pdf}" cat 2914-2930 output ch177_dbms_service.pdf

# ch178_dbms_session.pdf
# BookmarkTitle: 178 DBMS_SESSION, BookmarkLevel: 1, BookmarkPageNumber: 2931
# Next L1: 179 DBMS_SFW_ACL_ADMIN, Page: 2953
pdftk "${input_pdf}" cat 2931-2952 output ch178_dbms_session.pdf

# ch179_dbms_sfw_acl_admin.pdf
# BookmarkTitle: 179 DBMS_SFW_ACL_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 2953
# Next L1: 180 DBMS_SHARED_POOL, Page: 2959
pdftk "${input_pdf}" cat 2953-2958 output ch179_dbms_sfw_acl_admin.pdf

# ch180_dbms_shared_pool.pdf
# BookmarkTitle: 180 DBMS_SHARED_POOL, BookmarkLevel: 1, BookmarkPageNumber: 2959
# Next L1: 181 DBMS_SHARDING_DIRECTORY, Page: 2968
pdftk "${input_pdf}" cat 2959-2967 output ch180_dbms_shared_pool.pdf

# ch181_dbms_sharding_directory.pdf
# BookmarkTitle: 181 DBMS_SHARDING_DIRECTORY, BookmarkLevel: 1, BookmarkPageNumber: 2968
# Next L1: 182 DBMS_SODA, Page: 2974
pdftk "${input_pdf}" cat 2968-2973 output ch181_dbms_sharding_directory.pdf

# ch182_dbms_soda.pdf
# BookmarkTitle: 182 DBMS_SODA, BookmarkLevel: 1, BookmarkPageNumber: 2974
# Next L1: 183 DBMS_SPACE, Page: 2985
pdftk "${input_pdf}" cat 2974-2984 output ch182_dbms_soda.pdf

# ch183_dbms_space.pdf
# BookmarkTitle: 183 DBMS_SPACE, BookmarkLevel: 1, BookmarkPageNumber: 2985
# Next L1: 184 DBMS_SPACE_ADMIN, Page: 3003
pdftk "${input_pdf}" cat 2985-3002 output ch183_dbms_space.pdf

# ch184_dbms_space_admin.pdf
# BookmarkTitle: 184 DBMS_SPACE_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 3003
# Next L1: 185 DBMS_SPD, Page: 3020
pdftk "${input_pdf}" cat 3003-3019 output ch184_dbms_space_admin.pdf

# ch185_dbms_spd.pdf
# BookmarkTitle: 185 DBMS_SPD, BookmarkLevel: 1, BookmarkPageNumber: 3020
# Next L1: 186 DBMS_SPM, Page: 3029
pdftk "${input_pdf}" cat 3020-3028 output ch185_dbms_spd.pdf

# ch186_dbms_spm.pdf
# BookmarkTitle: 186 DBMS_SPM, BookmarkLevel: 1, BookmarkPageNumber: 3029
# Next L1: 187 DBMS_SQL, Page: 3058
pdftk "${input_pdf}" cat 3029-3057 output ch186_dbms_spm.pdf

# ch187_dbms_sql.pdf
# BookmarkTitle: 187 DBMS_SQL, BookmarkLevel: 1, BookmarkPageNumber: 3058
# Next L1: 188 DBMS_SQL_FIREWALL, Page: 3125
pdftk "${input_pdf}" cat 3058-3124 output ch187_dbms_sql.pdf

# ch188_dbms_sql_firewall.pdf
# BookmarkTitle: 188 DBMS_SQL_FIREWALL, BookmarkLevel: 1, BookmarkPageNumber: 3125
# Next L1: 189 DBMS_SQL_MONITOR, Page: 3146
pdftk "${input_pdf}" cat 3125-3145 output ch188_dbms_sql_firewall.pdf

# ch189_dbms_sql_monitor.pdf
# BookmarkTitle: 189 DBMS_SQL_MONITOR, BookmarkLevel: 1, BookmarkPageNumber: 3146
# Next L1: 190 DBMS_SQL_TRANSLATOR, Page: 3156
pdftk "${input_pdf}" cat 3146-3155 output ch189_dbms_sql_monitor.pdf

# ch190_dbms_sql_translator.pdf
# BookmarkTitle: 190 DBMS_SQL_TRANSLATOR, BookmarkLevel: 1, BookmarkPageNumber: 3156
# Next L1: 191 DBMS_SQLDIAG, Page: 3174
pdftk "${input_pdf}" cat 3156-3173 output ch190_dbms_sql_translator.pdf

# ch191_dbms_sqldiag.pdf
# BookmarkTitle: 191 DBMS_SQLDIAG, BookmarkLevel: 1, BookmarkPageNumber: 3174
# Next L1: 192 DBMS_SQLPA, Page: 3204
pdftk "${input_pdf}" cat 3174-3203 output ch191_dbms_sqldiag.pdf

# ch192_dbms_sqlpa.pdf
# BookmarkTitle: 192 DBMS_SQLPA, BookmarkLevel: 1, BookmarkPageNumber: 3204
# Next L1: 193 DBMS_SQLQ, Page: 3221
pdftk "${input_pdf}" cat 3204-3220 output ch192_dbms_sqlpa.pdf

# ch193_dbms_sqlq.pdf
# BookmarkTitle: 193 DBMS_SQLQ, BookmarkLevel: 1, BookmarkPageNumber: 3221
# Next L1: 194 DBMS_SQLSET, Page: 3230
pdftk "${input_pdf}" cat 3221-3229 output ch193_dbms_sqlq.pdf

# ch194_dbms_sqlset.pdf
# BookmarkTitle: 194 DBMS_SQLSET, BookmarkLevel: 1, BookmarkPageNumber: 3230
# Next L1: 195 DBMS_SQLTUNE, Page: 3264
pdftk "${input_pdf}" cat 3230-3263 output ch194_dbms_sqlset.pdf

# ch195_dbms_sqltune.pdf
# BookmarkTitle: 195 DBMS_SQLTUNE, BookmarkLevel: 1, BookmarkPageNumber: 3264
# Next L1: 196 DBMS_STAT_FUNCS, Page: 3354
pdftk "${input_pdf}" cat 3264-3353 output ch195_dbms_sqltune.pdf

# ch196_dbms_stat_funcs.pdf
# BookmarkTitle: 196 DBMS_STAT_FUNCS, BookmarkLevel: 1, BookmarkPageNumber: 3354
# Next L1: 197 DBMS_STATS, Page: 3359
pdftk "${input_pdf}" cat 3354-3358 output ch196_dbms_stat_funcs.pdf

# ch197_dbms_stats.pdf
# BookmarkTitle: 197 DBMS_STATS, BookmarkLevel: 1, BookmarkPageNumber: 3359
# Next L1: 198 DBMS_STORAGE_MAP, Page: 3612
pdftk "${input_pdf}" cat 3359-3611 output ch197_dbms_stats.pdf

# ch198_dbms_storage_map.pdf
# BookmarkTitle: 198 DBMS_STORAGE_MAP, BookmarkLevel: 1, BookmarkPageNumber: 3612
# Next L1: 199 DBMS_SYNC_REFRESH, Page: 3619
pdftk "${input_pdf}" cat 3612-3618 output ch198_dbms_storage_map.pdf

# ch199_dbms_sync_refresh.pdf
# BookmarkTitle: 199 DBMS_SYNC_REFRESH, BookmarkLevel: 1, BookmarkPageNumber: 3619
# Next L1: 200 DBMS_TABLE_DATA, Page: 3631
pdftk "${input_pdf}" cat 3619-3630 output ch199_dbms_sync_refresh.pdf

# ch200_dbms_table_data.pdf
# BookmarkTitle: 200 DBMS_TABLE_DATA, BookmarkLevel: 1, BookmarkPageNumber: 3631
# Next L1: 201 DBMS_TDB, Page: 3635
pdftk "${input_pdf}" cat 3631-3634 output ch200_dbms_table_data.pdf

# ch201_dbms_tdb.pdf
# BookmarkTitle: 201 DBMS_TDB, BookmarkLevel: 1, BookmarkPageNumber: 3635
# Next L1: 202 DBMS_TF, Page: 3640
pdftk "${input_pdf}" cat 3635-3639 output ch201_dbms_tdb.pdf

# ch202_dbms_tf.pdf
# BookmarkTitle: 202 DBMS_TF, BookmarkLevel: 1, BookmarkPageNumber: 3640
# Next L1: 203 DBMS_TNS, Page: 3692
pdftk "${input_pdf}" cat 3640-3691 output ch202_dbms_tf.pdf

# ch203_dbms_tns.pdf
# BookmarkTitle: 203 DBMS_TNS, BookmarkLevel: 1, BookmarkPageNumber: 3692
# Next L1: 204 DBMS_TRACE, Page: 3694
pdftk "${input_pdf}" cat 3692-3693 output ch203_dbms_tns.pdf

# ch204_dbms_trace.pdf
# BookmarkTitle: 204 DBMS_TRACE, BookmarkLevel: 1, BookmarkPageNumber: 3694
# Next L1: 205 DBMS_TRANSACTION, Page: 3700
pdftk "${input_pdf}" cat 3694-3699 output ch204_dbms_trace.pdf

# ch205_dbms_transaction.pdf
# BookmarkTitle: 205 DBMS_TRANSACTION, BookmarkLevel: 1, BookmarkPageNumber: 3700
# Next L1: 206 DBMS_TRANSFORM, Page: 3711
pdftk "${input_pdf}" cat 3700-3710 output ch205_dbms_transaction.pdf

# ch206_dbms_transform.pdf
# BookmarkTitle: 206 DBMS_TRANSFORM, BookmarkLevel: 1, BookmarkPageNumber: 3711
# Next L1: 207 DBMS_TSDP_MANAGE, Page: 3714
pdftk "${input_pdf}" cat 3711-3713 output ch206_dbms_transform.pdf

# ch207_dbms_tsdp_manage.pdf
# BookmarkTitle: 207 DBMS_TSDP_MANAGE, BookmarkLevel: 1, BookmarkPageNumber: 3714
# Next L1: 208 DBMS_TSDP_PROTECT, Page: 3721
pdftk "${input_pdf}" cat 3714-3720 output ch207_dbms_tsdp_manage.pdf

# ch208_dbms_tsdp_protect.pdf
# BookmarkTitle: 208 DBMS_TSDP_PROTECT, BookmarkLevel: 1, BookmarkPageNumber: 3721
# Next L1: 209 DBMS_TTS, Page: 3731
pdftk "${input_pdf}" cat 3721-3730 output ch208_dbms_tsdp_protect.pdf

# ch209_dbms_tts.pdf
# BookmarkTitle: 209 DBMS_TTS, BookmarkLevel: 1, BookmarkPageNumber: 3731
# Next L1: 210 DBMS_TYPES, Page: 3734
pdftk "${input_pdf}" cat 3731-3733 output ch209_dbms_tts.pdf

# ch210_dbms_types.pdf
# BookmarkTitle: 210 DBMS_TYPES, BookmarkLevel: 1, BookmarkPageNumber: 3734
# Next L1: 211 DBMS_UMF, Page: 3736
pdftk "${input_pdf}" cat 3734-3735 output ch210_dbms_types.pdf

# ch211_dbms_umf.pdf
# BookmarkTitle: 211 DBMS_UMF, BookmarkLevel: 1, BookmarkPageNumber: 3736
# Next L1: 212 DBMS_UNDO_ADV, Page: 3747
pdftk "${input_pdf}" cat 3736-3746 output ch211_dbms_umf.pdf

# ch212_dbms_undo_adv.pdf
# BookmarkTitle: 212 DBMS_UNDO_ADV, BookmarkLevel: 1, BookmarkPageNumber: 3747
# Next L1: 213 DBMS_USER_CERTS, Page: 3756
pdftk "${input_pdf}" cat 3747-3755 output ch212_dbms_undo_adv.pdf

# ch213_dbms_user_certs.pdf
# BookmarkTitle: 213 DBMS_USER_CERTS, BookmarkLevel: 1, BookmarkPageNumber: 3756
# Next L1: 214 DBMS_USERDIAG, Page: 3759
pdftk "${input_pdf}" cat 3756-3758 output ch213_dbms_user_certs.pdf

# ch214_dbms_userdiag.pdf
# BookmarkTitle: 214 DBMS_USERDIAG, BookmarkLevel: 1, BookmarkPageNumber: 3759
# Next L1: 215 DBMS_UTILITY, Page: 3764
pdftk "${input_pdf}" cat 3759-3763 output ch214_dbms_userdiag.pdf

# ch215_dbms_utility.pdf
# BookmarkTitle: 215 DBMS_UTILITY, BookmarkLevel: 1, BookmarkPageNumber: 3764
# Next L1: 216 DBMS_VECTOR, Page: 3796
pdftk "${input_pdf}" cat 3764-3795 output ch215_dbms_utility.pdf

# ch216_dbms_vector.pdf
# BookmarkTitle: 216 DBMS_VECTOR, BookmarkLevel: 1, BookmarkPageNumber: 3796
# Next L1: 217 DBMS_VECTOR_CHAIN, Page: 3853
pdftk "${input_pdf}" cat 3796-3852 output ch216_dbms_vector.pdf

# ch217_dbms_vector_chain.pdf
# BookmarkTitle: 217 DBMS_VECTOR_CHAIN, BookmarkLevel: 1, BookmarkPageNumber: 3853
# Next L1: 218 DBMS_WARNING, Page: 3914
pdftk "${input_pdf}" cat 3853-3913 output ch217_dbms_vector_chain.pdf

# ch218_dbms_warning.pdf
# BookmarkTitle: 218 DBMS_WARNING, BookmarkLevel: 1, BookmarkPageNumber: 3914
# Next L1: 219 DBMS_WM, Page: 3919
pdftk "${input_pdf}" cat 3914-3918 output ch218_dbms_warning.pdf

# ch219_dbms_wm.pdf
# BookmarkTitle: 219 DBMS_WM, BookmarkLevel: 1, BookmarkPageNumber: 3919
# Next L1: 220 DBMS_WORKLOAD_CAPTURE, Page: 3920
pdftk "${input_pdf}" cat 3919 output ch219_dbms_wm.pdf

# ch220_dbms_workload_capture.pdf
# BookmarkTitle: 220 DBMS_WORKLOAD_CAPTURE, BookmarkLevel: 1, BookmarkPageNumber: 3920
# Next L1: 221 DBMS_WORKLOAD_REPLAY, Page: 3932
pdftk "${input_pdf}" cat 3920-3931 output ch220_dbms_workload_capture.pdf

# ch221_dbms_workload_replay.pdf
# BookmarkTitle: 221 DBMS_WORKLOAD_REPLAY, BookmarkLevel: 1, BookmarkPageNumber: 3932
# Next L1: 222 DBMS_WORKLOAD_REPOSITORY, Page: 3968
pdftk "${input_pdf}" cat 3932-3967 output ch221_dbms_workload_replay.pdf

# ch222_dbms_workload_repository.pdf
# BookmarkTitle: 222 DBMS_WORKLOAD_REPOSITORY, BookmarkLevel: 1, BookmarkPageNumber: 3968
# Next L1: 223 DBMS_XDB, Page: 4008
pdftk "${input_pdf}" cat 3968-4007 output ch222_dbms_workload_repository.pdf

# ch223_dbms_xdb.pdf
# BookmarkTitle: 223 DBMS_XDB, BookmarkLevel: 1, BookmarkPageNumber: 4008
# Next L1: 224 DBMS_XA, Page: 4038
pdftk "${input_pdf}" cat 4008-4037 output ch223_dbms_xdb.pdf

# ch224_dbms_xa.pdf
# BookmarkTitle: 224 DBMS_XA, BookmarkLevel: 1, BookmarkPageNumber: 4038
# Next L1: 225 DBMS_XDB_ADMIN, Page: 4049
pdftk "${input_pdf}" cat 4038-4048 output ch224_dbms_xa.pdf

# ch225_dbms_xdb_admin.pdf
# BookmarkTitle: 225 DBMS_XDB_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 4049
# Next L1: 226 DBMS_XDB_CONFIG, Page: 4051
pdftk "${input_pdf}" cat 4049-4050 output ch225_dbms_xdb_admin.pdf

# ch226_dbms_xdb_config.pdf
# BookmarkTitle: 226 DBMS_XDB_CONFIG, BookmarkLevel: 1, BookmarkPageNumber: 4051
# Next L1: 227 DBMS_XDB_CONSTANTS, Page: 4067
pdftk "${input_pdf}" cat 4051-4066 output ch226_dbms_xdb_config.pdf

# ch227_dbms_xdb_constants.pdf
# BookmarkTitle: 227 DBMS_XDB_CONSTANTS, BookmarkLevel: 1, BookmarkPageNumber: 4067
# Next L1: 228 DBMS_XDB_REPOS, Page: 4077
pdftk "${input_pdf}" cat 4067-4076 output ch227_dbms_xdb_constants.pdf

# ch228_dbms_xdb_repos.pdf
# BookmarkTitle: 228 DBMS_XDB_REPOS, BookmarkLevel: 1, BookmarkPageNumber: 4077
# Next L1: 229 DBMS_XDB_VERSION, Page: 4098
pdftk "${input_pdf}" cat 4077-4097 output ch228_dbms_xdb_repos.pdf

# ch229_dbms_xdb_version.pdf
# BookmarkTitle: 229 DBMS_XDB_VERSION, BookmarkLevel: 1, BookmarkPageNumber: 4098
# Next L1: 230 DBMS_XDBRESOURCE, Page: 4105
pdftk "${input_pdf}" cat 4098-4104 output ch229_dbms_xdb_version.pdf

# ch230_dbms_xdbresource.pdf
# BookmarkTitle: 230 DBMS_XDBRESOURCE, BookmarkLevel: 1, BookmarkPageNumber: 4105
# Next L1: 231 DBMS_XDBZ, Page: 4128
pdftk "${input_pdf}" cat 4105-4127 output ch230_dbms_xdbresource.pdf

# ch231_dbms_xdbz.pdf
# BookmarkTitle: 231 DBMS_XDBZ, BookmarkLevel: 1, BookmarkPageNumber: 4128
# Next L1: 232 DBMS_XEVENT, Page: 4134
pdftk "${input_pdf}" cat 4128-4133 output ch231_dbms_xdbz.pdf

# ch232_dbms_xevent.pdf
# BookmarkTitle: 232 DBMS_XEVENT, BookmarkLevel: 1, BookmarkPageNumber: 4134
# Next L1: 233 DBMS_XMLDOM, Page: 4159
pdftk "${input_pdf}" cat 4134-4158 output ch232_dbms_xevent.pdf

# ch233_dbms_xmldom.pdf
# BookmarkTitle: 233 DBMS_XMLDOM, BookmarkLevel: 1, BookmarkPageNumber: 4159
# Next L1: 234 DBMS_XMLGEN, Page: 4248
pdftk "${input_pdf}" cat 4159-4247 output ch233_dbms_xmldom.pdf

# ch234_dbms_xmlgen.pdf
# BookmarkTitle: 234 DBMS_XMLGEN, BookmarkLevel: 1, BookmarkPageNumber: 4248
# Next L1: 235 DBMS_XMLINDEX, Page: 4259
pdftk "${input_pdf}" cat 4248-4258 output ch234_dbms_xmlgen.pdf

# ch235_dbms_xmlindex.pdf
# BookmarkTitle: 235 DBMS_XMLINDEX, BookmarkLevel: 1, BookmarkPageNumber: 4259
# Next L1: 236 DBMS_XMLPARSER, Page: 4265
pdftk "${input_pdf}" cat 4259-4264 output ch235_dbms_xmlindex.pdf

# ch236_dbms_xmlparser.pdf
# BookmarkTitle: 236 DBMS_XMLPARSER, BookmarkLevel: 1, BookmarkPageNumber: 4265
# Next L1: 237 DBMS_XMLSCHEMA, Page: 4274
pdftk "${input_pdf}" cat 4265-4273 output ch236_dbms_xmlparser.pdf

# ch237_dbms_xmlschema.pdf
# BookmarkTitle: 237 DBMS_XMLSCHEMA, BookmarkLevel: 1, BookmarkPageNumber: 4274
# Next L1: 238 DBMS_XMLSCHEMA_ANNOTATE, Page: 4289
pdftk "${input_pdf}" cat 4274-4288 output ch237_dbms_xmlschema.pdf

# ch238_dbms_xmlschema_annotate.pdf
# BookmarkTitle: 238 DBMS_XMLSCHEMA_ANNOTATE, BookmarkLevel: 1, BookmarkPageNumber: 4289
# Next L1: 239 DBMS_XMLSCHEMA_UTIL, Page: 4311
pdftk "${input_pdf}" cat 4289-4310 output ch238_dbms_xmlschema_annotate.pdf

# ch239_dbms_xmlschema_util.pdf
# BookmarkTitle: 239 DBMS_XMLSCHEMA_UTIL, BookmarkLevel: 1, BookmarkPageNumber: 4311
# Next L1: 240 DBMS_XMLSTORAGE_MANAGE, Page: 4316
pdftk "${input_pdf}" cat 4311-4315 output ch239_dbms_xmlschema_util.pdf

# ch240_dbms_xmlstorage_manage.pdf
# BookmarkTitle: 240 DBMS_XMLSTORAGE_MANAGE, BookmarkLevel: 1, BookmarkPageNumber: 4316
# Next L1: 241 DBMS_XMLSTORE, Page: 4327
pdftk "${input_pdf}" cat 4316-4326 output ch240_dbms_xmlstorage_manage.pdf

# ch241_dbms_xmlstore.pdf
# BookmarkTitle: 241 DBMS_XMLSTORE, BookmarkLevel: 1, BookmarkPageNumber: 4327
# Next L1: 242 DBMS_XPLAN, Page: 4333
pdftk "${input_pdf}" cat 4327-4332 output ch241_dbms_xmlstore.pdf

# ch242_dbms_xplan.pdf
# BookmarkTitle: 242 DBMS_XPLAN, BookmarkLevel: 1, BookmarkPageNumber: 4333
# Next L1: 243 DBMS_XSLPROCESSOR, Page: 4360
pdftk "${input_pdf}" cat 4333-4359 output ch242_dbms_xplan.pdf

# ch243_dbms_xslprocessor.pdf
# BookmarkTitle: 243 DBMS_XSLPROCESSOR, BookmarkLevel: 1, BookmarkPageNumber: 4360
# Next L1: 244 DBMS_XSTREAM_ADM, Page: 4369
pdftk "${input_pdf}" cat 4360-4368 output ch243_dbms_xslprocessor.pdf

# ch244_dbms_xstream_adm.pdf
# BookmarkTitle: 244 DBMS_XSTREAM_ADM, BookmarkLevel: 1, BookmarkPageNumber: 4369
# Next L1: 245 DEBUG_EXTPROC, Page: 4467
pdftk "${input_pdf}" cat 4369-4466 output ch244_dbms_xstream_adm.pdf

# ch245_debug_extproc.pdf
# BookmarkTitle: 245 DEBUG_EXTPROC, BookmarkLevel: 1, BookmarkPageNumber: 4467
# Next L1: 246 HTF, Page: 4469
pdftk "${input_pdf}" cat 4467-4468 output ch245_debug_extproc.pdf

# ch246_htf.pdf
# BookmarkTitle: 246 HTF, BookmarkLevel: 1, BookmarkPageNumber: 4469
# Next L1: 247 HTP, Page: 4543
pdftk "${input_pdf}" cat 4469-4542 output ch246_htf.pdf

# ch247_htp.pdf
# BookmarkTitle: 247 HTP, BookmarkLevel: 1, BookmarkPageNumber: 4543
# Next L1: 248 OWA_CACHE, Page: 4616
pdftk "${input_pdf}" cat 4543-4615 output ch247_htp.pdf

# ch248_owa_cache.pdf
# BookmarkTitle: 248 OWA_CACHE, BookmarkLevel: 1, BookmarkPageNumber: 4616
# Next L1: 249 OWA_COOKIE, Page: 4620
pdftk "${input_pdf}" cat 4616-4619 output ch248_owa_cache.pdf

# ch249_owa_cookie.pdf
# BookmarkTitle: 249 OWA_COOKIE, BookmarkLevel: 1, BookmarkPageNumber: 4620
# Next L1: 250 OWA_CUSTOM, Page: 4624
pdftk "${input_pdf}" cat 4620-4623 output ch249_owa_cookie.pdf

# ch250_owa_custom.pdf
# BookmarkTitle: 250 OWA_CUSTOM, BookmarkLevel: 1, BookmarkPageNumber: 4624
# Next L1: 251 OWA_IMAGE, Page: 4625
pdftk "${input_pdf}" cat 4624 output ch250_owa_custom.pdf

# ch251_owa_image.pdf
# BookmarkTitle: 251 OWA_IMAGE, BookmarkLevel: 1, BookmarkPageNumber: 4625
# Next L1: 252 OWA_OPT_LOCK, Page: 4628
pdftk "${input_pdf}" cat 4625-4627 output ch251_owa_image.pdf

# ch252_owa_opt_lock.pdf
# BookmarkTitle: 252 OWA_OPT_LOCK, BookmarkLevel: 1, BookmarkPageNumber: 4628
# Next L1: 253 OWA_PATTERN, Page: 4632
pdftk "${input_pdf}" cat 4628-4631 output ch252_owa_opt_lock.pdf

# ch253_owa_pattern.pdf
# BookmarkTitle: 253 OWA_PATTERN, BookmarkLevel: 1, BookmarkPageNumber: 4632
# Next L1: 254 OWA_SEC, Page: 4640
pdftk "${input_pdf}" cat 4632-4639 output ch253_owa_pattern.pdf

# ch254_owa_sec.pdf
# BookmarkTitle: 254 OWA_SEC, BookmarkLevel: 1, BookmarkPageNumber: 4640
# Next L1: 255 OWA_TEXT, Page: 4644
pdftk "${input_pdf}" cat 4640-4643 output ch254_owa_sec.pdf

# ch255_owa_text.pdf
# BookmarkTitle: 255 OWA_TEXT, BookmarkLevel: 1, BookmarkPageNumber: 4644
# Next L1: 256 OWA_UTIL, Page: 4648
pdftk "${input_pdf}" cat 4644-4647 output ch255_owa_text.pdf

# ch256_owa_util.pdf
# BookmarkTitle: 256 OWA_UTIL, BookmarkLevel: 1, BookmarkPageNumber: 4648
# Next L1: 257 SDO_CS, Page: 4665
pdftk "${input_pdf}" cat 4648-4664 output ch256_owa_util.pdf

# ch257_sdo_cs.pdf
# BookmarkTitle: 257 SDO_CS, BookmarkLevel: 1, BookmarkPageNumber: 4665
# Next L1: 258 SDO_CSW_PROCESS, Page: 4666
pdftk "${input_pdf}" cat 4665 output ch257_sdo_cs.pdf

# ch258_sdo_csw_process.pdf
# BookmarkTitle: 258 SDO_CSW_PROCESS, BookmarkLevel: 1, BookmarkPageNumber: 4666
# Next L1: 259 SDO_GCDR, Page: 4667
pdftk "${input_pdf}" cat 4666 output ch258_sdo_csw_process.pdf

# ch259_sdo_gcdr.pdf
# BookmarkTitle: 259 SDO_GCDR, BookmarkLevel: 1, BookmarkPageNumber: 4667
# Next L1: 260 SDO_GEOM, Page: 4668
pdftk "${input_pdf}" cat 4667 output ch259_sdo_gcdr.pdf

# ch260_sdo_geom.pdf
# BookmarkTitle: 260 SDO_GEOM, BookmarkLevel: 1, BookmarkPageNumber: 4668
# Next L1: 261 SDO_GEOR, Page: 4669
pdftk "${input_pdf}" cat 4668 output ch260_sdo_geom.pdf

# ch261_sdo_geor.pdf
# BookmarkTitle: 261 SDO_GEOR, BookmarkLevel: 1, BookmarkPageNumber: 4669
# Next L1: 262 SDO_GEOR_ADMIN, Page: 4670
pdftk "${input_pdf}" cat 4669 output ch261_sdo_geor.pdf

# ch262_sdo_geor_admin.pdf
# BookmarkTitle: 262 SDO_GEOR_ADMIN, BookmarkLevel: 1, BookmarkPageNumber: 4670
# Next L1: 263 SDO_GEOR_AGGR, Page: 4671
pdftk "${input_pdf}" cat 4670 output ch262_sdo_geor_admin.pdf

# ch263_sdo_geor_aggr.pdf
# BookmarkTitle: 263 SDO_GEOR_AGGR, BookmarkLevel: 1, BookmarkPageNumber: 4671
# Next L1: 264 SDO_GEOR_RA, Page: 4672
pdftk "${input_pdf}" cat 4671 output ch263_sdo_geor_aggr.pdf

# ch264_sdo_geor_ra.pdf
# BookmarkTitle: 264 SDO_GEOR_RA, BookmarkLevel: 1, BookmarkPageNumber: 4672
# Next L1: 265 SDO_GEOR_UTL, Page: 4673
pdftk "${input_pdf}" cat 4672 output ch264_sdo_geor_ra.pdf

# ch265_sdo_geor_utl.pdf
# BookmarkTitle: 265 SDO_GEOR_UTL, BookmarkLevel: 1, BookmarkPageNumber: 4673
# Next L1: 266 SDO_LRS, Page: 4674
pdftk "${input_pdf}" cat 4673 output ch265_sdo_geor_utl.pdf

# ch266_sdo_lrs.pdf
# BookmarkTitle: 266 SDO_LRS, BookmarkLevel: 1, BookmarkPageNumber: 4674
# Next L1: 267 SDO_MIGRATE, Page: 4675
pdftk "${input_pdf}" cat 4674 output ch266_sdo_lrs.pdf

# ch267_sdo_migrate.pdf
# BookmarkTitle: 267 SDO_MIGRATE, BookmarkLevel: 1, BookmarkPageNumber: 4675
# Next L1: 268 SDO_NET, Page: 4676
pdftk "${input_pdf}" cat 4675 output ch267_sdo_migrate.pdf

# ch268_sdo_net.pdf
# BookmarkTitle: 268 SDO_NET, BookmarkLevel: 1, BookmarkPageNumber: 4676
# Next L1: 269 SDO_NFE, Page: 4677
pdftk "${input_pdf}" cat 4676 output ch268_sdo_net.pdf

# ch269_sdo_nfe.pdf
# BookmarkTitle: 269 SDO_NFE, BookmarkLevel: 1, BookmarkPageNumber: 4677
# Next L1: 270 SDO_OLS, Page: 4678
pdftk "${input_pdf}" cat 4677 output ch269_sdo_nfe.pdf

# ch270_sdo_ols.pdf
# BookmarkTitle: 270 SDO_OLS, BookmarkLevel: 1, BookmarkPageNumber: 4678
# Next L1: 271 SDO_PC_PKG, Page: 4679
pdftk "${input_pdf}" cat 4678 output ch270_sdo_ols.pdf

# ch271_sdo_pc_pkg.pdf
# BookmarkTitle: 271 SDO_PC_PKG, BookmarkLevel: 1, BookmarkPageNumber: 4679
# Next L1: 272 SDO_SAM, Page: 4680
pdftk "${input_pdf}" cat 4679 output ch271_sdo_pc_pkg.pdf

# ch272_sdo_sam.pdf
# BookmarkTitle: 272 SDO_SAM, BookmarkLevel: 1, BookmarkPageNumber: 4680
# Next L1: 273 SDO_TIN_PKG, Page: 4681
pdftk "${input_pdf}" cat 4680 output ch272_sdo_sam.pdf

# ch273_sdo_tin_pkg.pdf
# BookmarkTitle: 273 SDO_TIN_PKG, BookmarkLevel: 1, BookmarkPageNumber: 4681
# Next L1: 274 SDO_TOPO, Page: 4682
pdftk "${input_pdf}" cat 4681 output ch273_sdo_tin_pkg.pdf

# ch274_sdo_topo.pdf
# BookmarkTitle: 274 SDO_TOPO, BookmarkLevel: 1, BookmarkPageNumber: 4682
# Next L1: 275 SDO_TOPO_MAP, Page: 4683
pdftk "${input_pdf}" cat 4682 output ch274_sdo_topo.pdf

# ch275_sdo_topo_map.pdf
# BookmarkTitle: 275 SDO_TOPO_MAP, BookmarkLevel: 1, BookmarkPageNumber: 4683
# Next L1: 276 SDO_TUNE, Page: 4684
pdftk "${input_pdf}" cat 4683 output ch275_sdo_topo_map.pdf

# ch276_sdo_tune.pdf
# BookmarkTitle: 276 SDO_TUNE, BookmarkLevel: 1, BookmarkPageNumber: 4684
# Next L1: 277 SDO_UTIL, Page: 4685
pdftk "${input_pdf}" cat 4684 output ch276_sdo_tune.pdf

# ch277_sdo_util.pdf
# BookmarkTitle: 277 SDO_UTIL, BookmarkLevel: 1, BookmarkPageNumber: 4685
# Next L1: 278 SDO_WFS_LOCK, Page: 4686
pdftk "${input_pdf}" cat 4685 output ch277_sdo_util.pdf

# ch278_sdo_wfs_lock.pdf
# BookmarkTitle: 278 SDO_WFS_LOCK, BookmarkLevel: 1, BookmarkPageNumber: 4686
# Next L1: 279 SDO_WFS_PROCESS, Page: 4687
pdftk "${input_pdf}" cat 4686 output ch278_sdo_wfs_lock.pdf

# ch279_sdo_wfs_process.pdf
# BookmarkTitle: 279 SDO_WFS_PROCESS, BookmarkLevel: 1, BookmarkPageNumber: 4687
# Next L1: 280 SEM_APIS, Page: 4688
pdftk "${input_pdf}" cat 4687 output ch279_sdo_wfs_process.pdf

# ch280_sem_apis.pdf
# BookmarkTitle: 280 SEM_APIS, BookmarkLevel: 1, BookmarkPageNumber: 4688
# Next L1: 281 SEM_OLS, Page: 4689
pdftk "${input_pdf}" cat 4688 output ch280_sem_apis.pdf

# ch281_sem_ols.pdf
# BookmarkTitle: 281 SEM_OLS, BookmarkLevel: 1, BookmarkPageNumber: 4689
# Next L1: 282 SEM_PERF, Page: 4690
pdftk "${input_pdf}" cat 4689 output ch281_sem_ols.pdf

# ch282_sem_perf.pdf
# BookmarkTitle: 282 SEM_PERF, BookmarkLevel: 1, BookmarkPageNumber: 4690
# Next L1: 283 SEM_RDFCTX, Page: 4691
pdftk "${input_pdf}" cat 4690 output ch282_sem_perf.pdf

# ch283_sem_rdfctx.pdf
# BookmarkTitle: 283 SEM_RDFCTX, BookmarkLevel: 1, BookmarkPageNumber: 4691
# Next L1: 284 SEM_RDFSA, Page: 4692
pdftk "${input_pdf}" cat 4691 output ch283_sem_rdfctx.pdf

# ch284_sem_rdfsa.pdf
# BookmarkTitle: 284 SEM_RDFSA, BookmarkLevel: 1, BookmarkPageNumber: 4692
# Next L1: 285 UTL_CALL_STACK, Page: 4693
pdftk "${input_pdf}" cat 4692 output ch284_sem_rdfsa.pdf

# ch285_utl_call_stack.pdf
# BookmarkTitle: 285 UTL_CALL_STACK, BookmarkLevel: 1, BookmarkPageNumber: 4693
# Next L1: 286 UTL_COLL, Page: 4702
pdftk "${input_pdf}" cat 4693-4701 output ch285_utl_call_stack.pdf

# ch286_utl_coll.pdf
# BookmarkTitle: 286 UTL_COLL, BookmarkLevel: 1, BookmarkPageNumber: 4702
# Next L1: 287 UTL_COMPRESS, Page: 4704
pdftk "${input_pdf}" cat 4702-4703 output ch286_utl_coll.pdf

# ch287_utl_compress.pdf
# BookmarkTitle: 287 UTL_COMPRESS, BookmarkLevel: 1, BookmarkPageNumber: 4704
# Next L1: 288 UTL_ENCODE, Page: 4712
pdftk "${input_pdf}" cat 4704-4711 output ch287_utl_compress.pdf

# ch288_utl_encode.pdf
# BookmarkTitle: 288 UTL_ENCODE, BookmarkLevel: 1, BookmarkPageNumber: 4712
# Next L1: 289 UTL_FILE, Page: 4721
pdftk "${input_pdf}" cat 4712-4720 output ch288_utl_encode.pdf

# ch289_utl_file.pdf
# BookmarkTitle: 289 UTL_FILE, BookmarkLevel: 1, BookmarkPageNumber: 4721
# Next L1: 290 UTL_HTTP, Page: 4746
pdftk "${input_pdf}" cat 4721-4745 output ch289_utl_file.pdf

# ch290_utl_http.pdf
# BookmarkTitle: 290 UTL_HTTP, BookmarkLevel: 1, BookmarkPageNumber: 4746
# Next L1: 291 UTL_I18N, Page: 4819
pdftk "${input_pdf}" cat 4746-4818 output ch290_utl_http.pdf

# ch291_utl_i18n.pdf
# BookmarkTitle: 291 UTL_I18N, BookmarkLevel: 1, BookmarkPageNumber: 4819
# Next L1: 292 UTL_IDENT, Page: 4855
pdftk "${input_pdf}" cat 4819-4854 output ch291_utl_i18n.pdf

# ch292_utl_ident.pdf
# BookmarkTitle: 292 UTL_IDENT, BookmarkLevel: 1, BookmarkPageNumber: 4855
# Next L1: 293 UTL_INADDR, Page: 4856
pdftk "${input_pdf}" cat 4855 output ch292_utl_ident.pdf

# ch293_utl_inaddr.pdf
# BookmarkTitle: 293 UTL_INADDR, BookmarkLevel: 1, BookmarkPageNumber: 4856
# Next L1: 294 UTL_LMS, Page: 4859
pdftk "${input_pdf}" cat 4856-4858 output ch293_utl_inaddr.pdf

# ch294_utl_lms.pdf
# BookmarkTitle: 294 UTL_LMS, BookmarkLevel: 1, BookmarkPageNumber: 4859
# Next L1: 295 UTL_MAIL, Page: 4862
pdftk "${input_pdf}" cat 4859-4861 output ch294_utl_lms.pdf

# ch295_utl_mail.pdf
# BookmarkTitle: 295 UTL_MAIL, BookmarkLevel: 1, BookmarkPageNumber: 4862
# Next L1: 296 UTL_MATCH, Page: 4867
pdftk "${input_pdf}" cat 4862-4866 output ch295_utl_mail.pdf

# ch296_utl_match.pdf
# BookmarkTitle: 296 UTL_MATCH, BookmarkLevel: 1, BookmarkPageNumber: 4867
# Next L1: 297 UTL_NLA, Page: 4871
pdftk "${input_pdf}" cat 4867-4870 output ch296_utl_match.pdf

# ch297_utl_nla.pdf
# BookmarkTitle: 297 UTL_NLA, BookmarkLevel: 1, BookmarkPageNumber: 4871
# Next L1: 298 UTL_RAW, Page: 4968
pdftk "${input_pdf}" cat 4871-4967 output ch297_utl_nla.pdf

# ch298_utl_raw.pdf
# BookmarkTitle: 298 UTL_RAW, BookmarkLevel: 1, BookmarkPageNumber: 4968
# Next L1: 299 UTL_RECOMP, Page: 4994
pdftk "${input_pdf}" cat 4968-4993 output ch298_utl_raw.pdf

# ch299_utl_recomp.pdf
# BookmarkTitle: 299 UTL_RECOMP, BookmarkLevel: 1, BookmarkPageNumber: 4994
# Next L1: 300 UTL_REF, Page: 4998
pdftk "${input_pdf}" cat 4994-4997 output ch299_utl_recomp.pdf

# ch300_utl_ref.pdf
# BookmarkTitle: 300 UTL_REF, BookmarkLevel: 1, BookmarkPageNumber: 4998
# Next L1: 301 UTL_RPADV, Page: 5004
pdftk "${input_pdf}" cat 4998-5003 output ch300_utl_ref.pdf

# ch301_utl_rpadv.pdf
# BookmarkTitle: 301 UTL_RPADV, BookmarkLevel: 1, BookmarkPageNumber: 5004
# Next L1: 302 UTL_SMTP, Page: 5025
pdftk "${input_pdf}" cat 5004-5024 output ch301_utl_rpadv.pdf

# ch302_utl_smtp.pdf
# BookmarkTitle: 302 UTL_SMTP, BookmarkLevel: 1, BookmarkPageNumber: 5025
# Next L1: 303 UTL_TCP, Page: 5051
pdftk "${input_pdf}" cat 5025-5050 output ch302_utl_smtp.pdf

# ch303_utl_tcp.pdf
# BookmarkTitle: 303 UTL_TCP, BookmarkLevel: 1, BookmarkPageNumber: 5051
# Next L1: 304 UTL_URL, Page: 5070
pdftk "${input_pdf}" cat 5051-5069 output ch303_utl_tcp.pdf

# ch304_utl_url.pdf
# BookmarkTitle: 304 UTL_URL, BookmarkLevel: 1, BookmarkPageNumber: 5070
# Next L1: 305 WPG_DOCLOAD, Page: 5075
pdftk "${input_pdf}" cat 5070-5074 output ch304_utl_url.pdf

# ch305_wpg_docload.pdf
# BookmarkTitle: 305 WPG_DOCLOAD, BookmarkLevel: 1, BookmarkPageNumber: 5075
# Next L1: 306 ANYDATA TYPE, Page: 5078
pdftk "${input_pdf}" cat 5075-5077 output ch305_wpg_docload.pdf

# ch306_anydata_type.pdf
# BookmarkTitle: 306 ANYDATA TYPE, BookmarkLevel: 1, BookmarkPageNumber: 5078
# Next L1: 307 ANYDATASET TYPE, Page: 5088
pdftk "${input_pdf}" cat 5078-5087 output ch306_anydata_type.pdf

# ch307_anydataset_type.pdf
# BookmarkTitle: 307 ANYDATASET TYPE, BookmarkLevel: 1, BookmarkPageNumber: 5088
# Next L1: 308 ANYTYPE TYPE, Page: 5099
pdftk "${input_pdf}" cat 5088-5098 output ch307_anydataset_type.pdf

# ch308_anytype_type.pdf
# BookmarkTitle: 308 ANYTYPE TYPE, BookmarkLevel: 1, BookmarkPageNumber: 5099
# Next L1: 309 Oracle Database Advanced Queuing (AQ) Types, Page: 5106
pdftk "${input_pdf}" cat 5099-5105 output ch308_anytype_type.pdf

# ch309_oracle_database_advanced_queuing_aq_types.pdf
# BookmarkTitle: 309 Oracle Database Advanced Queuing (AQ) Types, BookmarkLevel: 1, BookmarkPageNumber: 5106
# Next L1: 310 DBFS Content Interface Types, Page: 5126
pdftk "${input_pdf}" cat 5106-5125 output ch309_oracle_database_advanced_queuing_aq_types.pdf

# ch310_dbfs_content_interface_types.pdf
# BookmarkTitle: 310 DBFS Content Interface Types, BookmarkLevel: 1, BookmarkPageNumber: 5126
# Next L1: 311 Database URI TYPEs, Page: 5130
pdftk "${input_pdf}" cat 5126-5129 output ch310_dbfs_content_interface_types.pdf

# ch311_database_uri_types.pdf
# BookmarkTitle: 311 Database URI TYPEs, BookmarkLevel: 1, BookmarkPageNumber: 5130
# Next L1: 312 JMS Types, Page: 5147
pdftk "${input_pdf}" cat 5130-5146 output ch311_database_uri_types.pdf

# ch312_jms_types.pdf
# BookmarkTitle: 312 JMS Types, BookmarkLevel: 1, BookmarkPageNumber: 5147
# Next L1: 313 JSON Data Structures, Page: 5194
pdftk "${input_pdf}" cat 5147-5193 output ch312_jms_types.pdf

# ch313_json_data_structures.pdf
# BookmarkTitle: 313 JSON Data Structures, BookmarkLevel: 1, BookmarkPageNumber: 5194
# Next L1: 314 Logical Change Record TYPEs, Page: 5204
pdftk "${input_pdf}" cat 5194-5203 output ch313_json_data_structures.pdf

# ch314_logical_change_record_types.pdf
# BookmarkTitle: 314 Logical Change Record TYPEs, BookmarkLevel: 1, BookmarkPageNumber: 5204
# Next L1: 315 MGD_ID Package Types, Page: 5250
pdftk "${input_pdf}" cat 5204-5249 output ch314_logical_change_record_types.pdf

# ch315_mgd_id_package_types.pdf
# BookmarkTitle: 315 MGD_ID Package Types, BookmarkLevel: 1, BookmarkPageNumber: 5250
# Next L1: 316 Rule TYPEs, Page: 5262
pdftk "${input_pdf}" cat 5250-5261 output ch315_mgd_id_package_types.pdf

# ch316_rule_types.pdf
# BookmarkTitle: 316 Rule TYPEs, BookmarkLevel: 1, BookmarkPageNumber: 5262
# Next L1: 317 SODA Types, Page: 5275
pdftk "${input_pdf}" cat 5262-5274 output ch316_rule_types.pdf

# ch317_soda_types.pdf
# BookmarkTitle: 317 SODA Types, BookmarkLevel: 1, BookmarkPageNumber: 5275
# Next L1: 318 UTL Streams Types, Page: 5305
pdftk "${input_pdf}" cat 5275-5304 output ch317_soda_types.pdf

# ch318_utl_streams_types.pdf
# BookmarkTitle: 318 UTL Streams Types, BookmarkLevel: 1, BookmarkPageNumber: 5305
# Next L1: 319 XMLTYPE, Page: 5310
pdftk "${input_pdf}" cat 5305-5309 output ch318_utl_streams_types.pdf

# ch319_xmltype.pdf
# BookmarkTitle: 319 XMLTYPE, BookmarkLevel: 1, BookmarkPageNumber: 5310
# Next L1: Index, Page: 5321
pdftk "${input_pdf}" cat 5310-5320 output ch319_xmltype.pdf

# index.pdf
# BookmarkTitle: Index, BookmarkLevel: 1, BookmarkPageNumber: 5321
# Last section, end page is total pages
pdftk "${input_pdf}" cat 5321-5375 output index.pdf

echo "Chapter extraction complete."
