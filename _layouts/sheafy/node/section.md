<section>
  {% unless page.topmost -%}
    <h{{ page.depth | plus: 1 }} id="{{ page.slug }}">
      <span class="numbering">{{ page.iso_2145 }}.</span>
      {{ page.title }}
      <a class="slug" href="{{ page.url | relative_url }}">[{{ page.slug }}]</a>
    </h{{ page.depth | plus: 1 }}>
  {%- endunless %}
  {{ content }}
</section>
