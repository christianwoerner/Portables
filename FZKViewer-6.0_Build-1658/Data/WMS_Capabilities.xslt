<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:wms="http://www.opengis.net/wms"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink>"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.opengis.net/wms http://svs.gsfc.nasa.gov/capabilities_1_3_0.xsd">

  <xsl:template match="/">
    <html>
      <head>
        <link href="##DATAPATH##capability.css" rel="stylesheet" type="text/css" />
      </head>
      <body>
        <xsl:apply-templates select="//wms:Service"/>

        <h3>Statistik</h3>
        <table class="statistics">
          <tr>
            <th>Unterstützte Requests (<xsl:value-of select="count(//wms:Request/*)"/>)</th>
            <td>
              <xsl:for-each select="//wms:Request/*">
                <xsl:value-of select="name(.)"/><br/>
              </xsl:for-each>
            </td>
          </tr>
          <tr>
            <th>Layers (<xsl:value-of select="count(//wms:Layer)"/>)</th>
            <td>
              <xsl:for-each select="//wms:Layer">
                <xsl:value-of select="wms:Title"/>
                <br/>
              </xsl:for-each>
            </td>
          </tr>
          <tr>
            <th>Koordinatensysteme</th>
            <td>
              <xsl:for-each select="//wms:SRS">
                <xsl:if test="not(text()=preceding::text())">
                  <xsl:copy-of select="text()"/>
                  <br/>
                </xsl:if>
              </xsl:for-each>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="wms:Service">
    <h1>
      <xsl:value-of select="wms:Title" />
    </h1>
    <h2>
      <xsl:value-of select="wms:OnlineResource/@*[local-name()='href']" />
    </h2>
    <p>
      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    </p>
    <xsl:apply-templates select="wms:ContactInformation" />
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    <h3>Service-Info</h3>
    <table class="service">
      <xsl:if test="count(wms:Abstract) != 0">
      <tr>
        <th>Abstract</th>
        <td>
          <xsl:value-of select="wms:Abstract" />
        </td>
      </tr>
      </xsl:if>
      <xsl:if test="count(wms:KeywordList) != 0">
        <tr>
          <th>Schlüsselwörter</th>
          <td>
            <xsl:for-each select="wms:KeywordList/wms:Keyword">
              <xsl:value-of select="."/>, 
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="count(wms:Fees) != 0">
        <tr>
        <th>Gebühren</th>
        <td>
          <xsl:value-of select="wms:Fees" />
        </td>
      </tr>
      </xsl:if>
      <xsl:if test="count(wms:AccessConstraints) != 0">
      <tr>
        <th>Beschränkungen</th>
        <td>
          <xsl:value-of select="wms:AccessConstraints" />
        </td>
      </tr>
      </xsl:if>
      <tr>
        <th>Schema</th>
        <td>
          <xsl:value-of select="name(/*)"/>
          (Version <xsl:value-of select="/*/@version"/>)
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="wms:ContactInformation">
    <h3>Kontakt</h3>
    <table class="person">
      <tr>
        <th>Kontaktperson</th>
        <td>
          <xsl:value-of select="wms:ContactPersonPrimary/wms:ContactPerson"/>
          <br/>
          <xsl:value-of select="wms:ContactPersonPrimary/wms:ContactOrganization"/>
          <br/>
          <xsl:value-of select="wms:ContactPosition"/>
        </td>
      </tr>
      <tr>
        <th>Anschrift</th>
        <td>
          <xsl:value-of select="wms:ContactAddress/wms:Address"/><br/>
          <xsl:value-of select="wms:ContactAddress/wms:PostCode"/>
          <xsl:text> </xsl:text> <xsl:value-of select="wms:ContactAddress/wms:City"/><br/>
          <xsl:value-of select="wms:ContactAddress/wms:Country"/>
          <br/>
        </td>
      </tr>
      <tr>
        <th>Telefon</th>
        <td>
          <xsl:value-of select="wms:ContactVoiceTelephone"/>
        </td>
      </tr>
      <tr>
        <th>Fax</th>
        <td>
          <xsl:value-of select="wms:ContactFacsimileTelephone"/>
        </td>
      </tr>
      <tr>
        <th>E-Mail</th>
        <td>
          <xsl:value-of select="wms:ContactElectronicMailAddress"/>
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet> 
