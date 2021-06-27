<?xml version="1.0" encoding="utf8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:s="http://sqlfairy.sourceforge.net/sqlfairy.xml">
	<xsl:output method="html" encoding="utf8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>

	<xsl:template match="database">
		<html lang="ja">
			<head>
				<meta charset="utf-8"/>
				<title>テーブル定義</title>
				<style>
					.page {
						width:960px;
						margin:0 auto 100px auto;
					}
					table {
						width:100%;
						table-layout:fixed;
						border-collapse:collapse;
					}
					th, td {
						word-wrap:break-word;
						border:1px solid #999;
					}

					@media print {
						.page {
							width:100%;
							margin:0;
							page-break-after:always;
						}
					}
				</style>
			</head>
			<body>
				<div class="page" style="text-align:center;">
					<h1 style="padding:30mm 0;">テーブル定義書</h1>
					<p>株式会社ソフテル</p>
					<p>作成: 2015/07/01</p>
				</div>
				<xsl:apply-templates select="table_structure"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="table_structure">
		<div class="page">
			<table class="table table-bordered htable" style="margin-bottom:1em;">
				<colgroup>
					<col style="width:30%;" />
					<col style="" />
				</colgroup>
				<tbody>
					<tr>
						<th>テーブル名</th>
						<td><xsl:value-of select="@name"/></td>
					</tr>
					<tr>
						<th>備考</th>
						<td>
							<xsl:value-of select="options/@Comment"/>
						</td>
					</tr>
				</tbody>
			</table>
			<table class="table table-condensed">
				<colgroup>
					<col style="width:3em;" />
					<col style="max-width:50%;" />
					<col style="max-width:50%;" />
					<col style="width:4em;" />
					<col style="width:5em;" />
					<col style="width:5em;" />
					<col style="width:5em;" />
					<col style="" />
				</colgroup>
				<thead>
					<tr style="white-space:nowrap;">
						<th class="text-right">#</th>
						<th>物理名</th>
						<th>型</th>
						<th>NULL</th>
						<th>初期値</th>
						<th>主キー</th>
						<th>ユニーク</th>
						<th>備考</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="field"/>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="field">
		<tr>
			<td class="text-right"><xsl:value-of select="position()"/></td>
			<td><xsl:value-of select="@Field"/></td>
			<td><xsl:value-of select="@Type"/></td>
			<td style="text-align:center;"><xsl:if test="@Null='YES'">○</xsl:if></td>
			<td><xsl:value-of select="@Default"/></td>
			<td style="text-align:center;"><xsl:if test="@Key='PRI'">○</xsl:if></td>
			<td style="text-align:center;"><xsl:if test="@Key='UNI'">○</xsl:if></td>
			<td><xsl:value-of select="@Comment"/></td>
		</tr>
	</xsl:template>

</xsl:stylesheet>