<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:include href="http://localhost:8984/synopsx/files/xsl/tei2html.xsl"/>
	
	<xsl:template match="div[@type]">
 
		<div class="{@type}">
			<xsl:apply-templates></xsl:apply-templates>
		</div>
   <hr/>
	</xsl:template>
  
  	<!-- normalisation des espaces (http://wiki.tei-c.org/index.php/XML_Whitespace) -->
	<xsl:template match="pb">
 
		<h3 class="{local-name(.)}">
			Page <xsl:value-of select="@n|@ana"/>
		</h3>

	</xsl:template>

</xsl:stylesheet>
