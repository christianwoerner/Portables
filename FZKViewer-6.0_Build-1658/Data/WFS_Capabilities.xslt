<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:ows="http://www.opengis.net/ows"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink>"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:template match="/">
    <html>
      <head>
        <link href="##DATAPATH##capability.css" rel="stylesheet" type="text/css" />
      </head>
      <body>
        <xsl:apply-templates select="wfs:WFS_Capabilities"/>

        <h3>Statistik</h3>
        <table class="statistics">
          <tr>
            <th>Unterstützte Requests (<xsl:value-of select="count(//ows:Operation)"/>)</th>
            <td>
              <xsl:for-each select="//ows:Operation">
                <xsl:value-of select="@name"/><br/>
              </xsl:for-each>
            </td>
          </tr>
          <tr>
            <th>Feature Types (<xsl:value-of select="count(//wfs:FeatureType)"/>)</th>
            <td>
              <xsl:for-each select="//wfs:FeatureType">
                <xsl:value-of select="wfs:Name"/>
                <br/>
              </xsl:for-each>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>

    <xsl:template match="wfs:WFS_Capabilities">
    <h1>
      <xsl:value-of select="ows:ServiceIdentification/ows:Title" />
    </h1>
    <h2>
      <xsl:value-of select="ows:OnlineResource/@*[local-name()='href']" />
    </h2>
    <p>
      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    </p>
    <xsl:apply-templates select="//ows:ServiceProvider" />
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    <h3>Service-Info</h3>
    <table class="service">
      <xsl:if test="count(ows:ServiceIdentification/ows:Abstract) != 0">
      <tr>
        <th>Abstract</th>
        <td>
          <xsl:value-of select="ows:ServiceIdentification/ows:Abstract" />
        </td>
      </tr>
      </xsl:if>
      <xsl:if test="count(ows:ServiceIdentification/ows:Keywords) != 0">
        <tr>
          <th>Schlüsselwörter</th>
          <td>
            <xsl:for-each select="ows:ServiceIdentification/ows:Keywords/ows:Keyword">
              <xsl:value-of select="."/>, 
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="count(ows:ServiceIdentification/ows:Fees) != 0">
      <tr>
        <th>Gebühren</th>
        <td>
          <xsl:value-of select="ows:ServiceIdentification/ows:Fees" />
        </td>
      </tr>
      </xsl:if>
      <xsl:if test="count(ows:ServiceIdentification/ows:AccessConstraints) != 0">
      <tr>
        <th>Beschränkungen</th>
        <td>
          <xsl:value-of select="ows:ServiceIdentification/ows:AccessConstraints" />
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

  <xsl:template match="//ows:ServiceProvider">
    <h3>Kontakt</h3>
    <table class="person">
      <tr>
        <th>Kontaktperson</th>
        <td>
          <xsl:value-of select="ows:ServiceContact/ows:IndividualName"/>
          <br/>
          <xsl:value-of select="ows:ProviderName"/>
          <br/>
          <xsl:value-of select="ows:ServiceContact/ows:PositionName"/>
        </td>
      </tr>
      <tr>
        <th>Anschrift</th>
        <td>
          <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Address/ows:DeliveryPoint"/><br/>
          <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Address/ows:PostalCode"/>
          <xsl:text> </xsl:text> <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Address/ows:City"/><br/>
          <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Address/ows:Country"/>
          <br/>
        </td>
      </tr>
      <tr>
        <th>Telefon</th>
        <td>
          <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Phone/ows:Voice"/>
        </td>
      </tr>
      <tr>
        <th>Fax</th>
        <td>
          <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Phone/ows:Facsimile"/>
        </td>
      </tr>
      <tr>
        <th>E-Mail</th>
        <td>
          <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Address/ows:ElectronicMailAddress"/>
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet> 
