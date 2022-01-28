<section>

{::nomarkdown}

<header id="{{ page.slug }}">
  <h{{ page.depth | plus: 1 }}>
    {% if page.depth == 0 %}
      {{ page.title }}
    {% else %}
      <span class="numbering">{{ page.clicks | to_numbering }}.</span>
      {{ page.title }}
      <a class="slug" href="{{ page.url | relative_url }}">[{{ page.slug }}]</a>
    {% endif %}
  </h{{ page.depth | plus: 1 }}>
</header>

{% if page == page.subroot %}
  {% assign filtered_resources = page.children | where: "taxon", "section" %}
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
