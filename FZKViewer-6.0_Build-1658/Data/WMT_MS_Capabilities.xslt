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
        <xsl:apply-templates select="//Service"/>

        <h3>Statistik</h3>
        <table class="statistics">
          <tr>
            <th>Unterstützte Requests (<xsl:value-of select="count(//Request/*)"/>)</th>
            <td>
              <xsl:for-each select="//Request/*">
                <xsl:value-of select="name(.)"/><br/>
              </xsl:for-each>
            </td>
          </tr>
          <tr>
            <th>Layers (<xsl:value-of select="count(//Layer)"/>)</th>
            <td>
              <xsl:for-each select="//Layer">
                <xsl:value-of select="Title"/>
                <br/>
              </xsl:for-each>
            </td>
          </tr>
          <tr>
            <th>Koordinatensysteme</th>
            <td>
              <xsl:for-each select="//SRS">
                <xsl:if test="not(text()=preceding::text())">
                  <xsl:copy-of select="text()"/><br/>
                </xsl:if>
              </xsl:for-each>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="Service">
    <h1>
      <xsl:value-of select="Title" />
    </h1>
    <h2>
      <xsl:value-of select="OnlineResource/@*[local-name()='href']" />
    </h2>
    <p>
      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    </p>
    <xsl:apply-templates select="ContactInformation" />
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    <h3>Service-Info</h3>
    <table class="service">
      <xsl:if test="count(Abstract) != 0">
        <tr>
          <th>Abstract</th>
          <td>
            <xsl:value-of select="Abstract" />
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="count(KeywordList) != 0">
        <tr>
          <th>Schlüsselwörter</th>
          <td>
            <xsl:for-each select="KeywordList/Keyword">
              <xsl:value-of select="."/>, 
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="count(Fees) != 0">
        <tr>
          <th>Gebühren</th>
          <td>
            <xsl:value-of select="Fees" />
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="count(AccessConstraints) != 0">
        <tr>
          <th>Beschränkungen</th>
          <td>
            <xsl:value-of select="AccessConstraints" />
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

  <xsl:template match="//Service/ContactInformation">
    <h3>Kontakt</h3>
    <table class="person">
      <tr>
        <th>Kontaktperson</th>
        <td>
          <xsl:value-of select="ContactPersonPrimary/ContactPerson"/>
          <br/>
          <xsl:value-of select="ContactPersonPrimary/ContactOrganization"/>
          <br/>
          <xsl:value-of select="ContactPosition"/>
        </td>
      </tr>
      <tr>
        <th>Anschrift</th>
        <td>
          <xsl:value-of select="ContactPosition"/><br/>
          <xsl:value-of select="ContactAddress/Address"/><br/>
          <xsl:value-of select="ContactAddress/PostCode"/>
          <xsl:text> </xsl:text> <xsl:value-of select="ContactAddress/City"/>
          <br/>
        </td>
      </tr>
      <tr>
        <th>Telefon</th>
        <td>
          <xsl:value-of select="ContactVoiceTelephone"/>
        </td>
      </tr>
      <tr>
        <th>Fax</th>
        <td>
          <xsl:value-of select="ContactFacsimileTelephone"/>
        </td>
      </tr>
      <tr>
        <th>E-Mail</th>
        <td>
          <xsl:value-of select="ContactElectronicMailAddress"/>
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet> 
