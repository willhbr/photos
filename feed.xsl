---
---
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
        <title><xsl:value-of select="rss/channel/title"/></title>
        <link rel="stylesheet" href="/css/main.css"/>
      </head>
      <body>
        <header class="site-header">
          <a href="/" class="title">
            {{ site.title }}
          </a>
        </header>
        <div class="container">
          <div class="post-body">
            <p>You've found the RSS feed. Subscribe by copying the current URL into your feed reader of choice.
            I use and recommend <a href="https://netnewswire.com/" target="_blank">NetNewsWire</a>.
            I also generate a <a href="{{ site.feeds.json_url | absolute_url }}" target="_blank">JSON Feed</a> with the same content.</p>
            <ul>
              <li>RSS URL: <code>{{ site.feeds.rss_url | absolute_url}}</code></li>
              <li>JSON Feed URL: <code>{{ site.feeds.json_url | absolute_url}}</code></li>
            </ul>

            <p>You can also read the <a href="{{ site.url }}">non-feed version of my website</a>.</p>
          </div>

          <ul>
            <xsl:apply-templates select="rss/channel/item" />
          </ul>
        </div>

        <footer>
          <p>&#169; <a href="/me">Will Richardson</a> 2014-{{ site.time | date: '%Y' }}</p>
          <p>All views and opinions expressed here are solely my own.</p>
        </footer>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="rss/channel/item">
    <li>
      <a target="_blank">
        <xsl:attribute name="href">
          <xsl:value-of select="link"/>
        </xsl:attribute>
        <xsl:value-of select="title"/>
      </a>
      <span class="metadata"> (<xsl:value-of select="pubDate"/>)</span>
    </li>
  </xsl:template>

</xsl:stylesheet>
