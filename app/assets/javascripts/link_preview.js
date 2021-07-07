  // document.addEventListener("turbolinks:load", function () {
  //   const SITE_URL = document.getElementById("url_<%= post.id %>");
  //   console.log(SITE_URL);

  // if (SITE_URL != null) {
  //   const data = { key: 'f53cb9eed3ed4cebbaeb983ad7e3decb', q: SITE_URL.href };
  //   fetch('https://api.linkpreview.net', {
  //     method: 'POST',
  //     mode: 'cors',
  //     body: JSON.stringify(data),
  //   })
  //   .then(data => data.json())
  //   .then(json => {
  //     console.log(json);
  //     document.getElementById("h_<%= post.id%>").innerHTML = json.title;
  //     document.getElementById("img_<%= post.id %>").src = json.image
  //     document.getElementById("a_<%= post.id %>").href = json.url
  //   })
  // }
  // })