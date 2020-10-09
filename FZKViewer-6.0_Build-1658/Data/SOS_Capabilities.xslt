<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:svc="http://www.opengis.net/sos/1.0"
    xmlns:ows="http://www.opengis.net/ows/1.1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.opengis.net/wms http://svs.gsfc.nasa.gov/capabilities_1_3_0.xsd">

  <xsl:template match="/">
    <html>
      <head>
        <link href="##DATAPATH##capability.css" rel="stylesheet" type="text/css" />
      </head>
      <body>
        <xsl:apply-templates select="//ows:ServiceIdentification"/>
        <xsl:apply-templates select="//ows:ServiceProvider" />

        <h3>Statistik XXX</h3>
        <table class="statistics">
          <tr>
            <th>
              Unterstützte Requests (<xsl:value-of select="count(//ows:Operation)"/>)
            </th>
            <td>
              <xsl:for-each select="//ows:Operation">
                <xsl:value-of select="@name"/>
                <br/>
              </xsl:for-each>
            </td>
          </tr>
          <tr>
            <th>
              Layers (<xsl:value-of select="count(//svc:Contents/svc:Layer)"/>)
            </th>
            <td>
              <xsl:for-each select="//svc:Contents/svc:Layer">
                <xsl:if test="count(ows:Title) != 0">
                  <xsl:value-of select="ows:Title"/>
                </xsl:if>
                <xsl:if test="count(ows:Name) != 0">
                  <xsl:value-of select="ows:Name"/>
                </xsl:if>
                <xsl:if test="count(ows:Identifier) != 0">
                  <xsl:value-of select="ows:Identifier"/>
                </xsl:if>
                <br/>
              </xsl:for-each>
            </td>
          </tr>
          <tr>
            <th>Koordinatensysteme</th>
            <td>
              <xsl:for-each select="//svc:Contents/svc:Layer/ows:AvailableCRS">
                <xsl:if test="not(text()=preceding::text())">
                  <xsl:copy-of select="text()"/>
                  <br/>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="//svc:Contents/svc:Layer/svc:SRS">
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

  <xsl:template match="ows:ServiceIdentification">
    <h1>
      <xsl:value-of select="ows:Title" />
    </h1>
    <h2>
      <xsl:value-of select="ows:OnlineResource/@*[local-name()='href']" />
    </h2>
    <xsl:if test="ows:ServiceType">
      <p>
        Angebotener Dienst:
        <xsl:value-of select="ows:ServiceType"/>
        <xsl:if test ="ows:ServiceTypeVersion">
          <xsl:text> (Version </xsl:text>
          <xsl:for-each select="ows:ServiceTypeVersion">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>)
        </xsl:if>
        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
      </p>
    </xsl:if>

    <xsl:apply-templates select="ows:ServiceProvider" />

    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    <h3>Service-Info</h3>
    <table class="service">
      <xsl:if test="count(ows:Abstract) != 0">
        <tr>
          <th>Abstract</th>
          <td>
            <xsl:value-of select="ows:Abstract" />
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="count(ows:Keywords) != 0">
        <tr>
          <th>Schlüsselwörter</th>
          <td>
            <xsl:for-each select="ows:Keywords/ows:Keyword">
              <xsl:value-of select="."/>
              <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="count(ows:Fees) != 0">
        <tr>
          <th>Gebühren</th>
          <td>
            <xsl:value-of select="ows:Fees" />
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="count(ows:AccessConstraints) != 0">
        <tr>
          <th>Beschränkungen</th>
          <td>
            <xsl:value-of select="ows:AccessConstraints" />
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

  <xsl:template match="ows:ServiceProvider">
    <h3>Anbieter</h3>
    <table class="person">
      <tr>
        <th>Anbieter</th>
        <td>
          <xsl:value-of select="ows:ProviderName"/>
          <xsl:variable name="providerSite" select="ows:ProviderSite/@xlink:href"/>
          <xsl:if test="ows:ProviderSite">
            <xsl:text> (</xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$providerSite"/>
              </xsl:attribute>
              <xsl:value-of select="$providerSite"/>
            </xsl:element>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </td>
      </tr>
      <tr>
        <th>Kontaktperson</th>
        <td>
          <xsl:value-of select="ows:ServiceContact/ows:IndividualName"/>
          <br/>
          <xsl:value-of select="ows:ServiceContact/ows:PositionName"/>
        </td>
      </tr>
      <tr>
        <th>Anschrift</th>
        <td>
          <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Address/ows:DeliveryPoint"/>
          <br/>
          <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Address/ows:PostalCode"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Address/ows:City"/>
          <br/>
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
      <xsl:if test="ows:ServiceContact/ows:ContactInfo/ows:Phone/ows:Facsimile">
        <tr>
          <th>Fax</th>
          <td>
            <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Phone/ows:Facsimile"/>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <th>E-Mail</th>
        <td>
          <xsl:value-of select="ows:ServiceContact/ows:ContactInfo/ows:Address/ows:ElectronicMailAddress"/>
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>
