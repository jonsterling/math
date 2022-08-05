<section id="{{ page.slug }}">

{::nomarkdown}

<header>
  <h{{ page.depth | plus: 1 }}>
    {% if page.depth == 0 %}
      {{ page.title }}
    {% else %}
      <span class="numbering">{{ page.clicks | to_numbering }}.</span>
      {{ page.title }}
      <a class="slug" href="{{ page.url | relative_url }}">[{{ page.slug }}]</a>
    {% endif %}
  </h{{ page.depth | plus: 1 }}>
  {%- if page.author -%}
  <p>
    by {% for author in page.author %}
      <span itemprop="author" itemscope itemtype="http://schema.org/Person">
      <span class="p-author h-card" itemprop="name">{{ author }}</span></span>
      {%- if forloop.last == false %}, {% endif -%}
    {% endfor %}
  </p>
  {%- endif -%}
</header>

{% if page == page.subroot %}
  {% assign filtered_resources = page.children | where: "clicker", "section" %}
  {% if filtered_resources.size != 0 %}
    <nav>
      <h4>Table of Contents</h4>
      {% include toc.html page=page %}
    </nav>
  {% endif %}
{% endif %}

{:/}

{{ content }}

</section>
