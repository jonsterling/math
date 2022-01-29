<section>

{::nomarkdown}

<header class="inline" id="{{ page.slug }}">
  <a class="slug" href="{{ page.url | relative_url }}">[{{ page.slug }}]</a>
  {{page | display_title_parenthetical -}}.
</header>

{:/}

{{ content }}

</section>
