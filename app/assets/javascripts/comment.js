$(function(){
  let buildHTML = function(data){
  if(data.user_id == data.product_id){
      let html = `<div class="seller-message" data-id="${data.id}">
                    <ul class="seller-message__items">
                      <li class="seller-message__contents">
                        <div class="seller-message__contents__items">
                            <p class="seller-message__contents__items__user--right">
                              ${data.nickname}(出品者)
                            </p>
                          <div class="seller-message__contents__items__body">
                            <div class="seller-message__contents__items__body--text">${data.text}</div>
                            <div class="seller-message__contents__items__body--icons">
                              <time class="seller-message__contents__items__body--icons--left">
                                <i class="fas fa-clock"></i>
                                <span>
                                ${data.created_at}
                                </span>
                              </time>
                              <div class="seller-message__contents__items__body--icons--right">
                                <div class="seller-message__contents__items__body--icons--right--delete" data-product=${data.product_id} data-comment=${data.id}>
                                  <i class="fas fa-trash-alt"></i>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </li> 
                    </ul>
                  </div>`
      return html
  }else{
      let html = `<div class="seller-message" data-id="${data.id}">
                    <ul class="seller-message__items">
                      <li class="seller-message__contents">
                        <div class="seller-message__contents__items">
                            <p class="seller-message__contents__items__user--left">
                              ${data.nickname}
                            </p>
                          <div class="seller-message__contents__items__body">
                            <div class="seller-message__contents__items__body--text">${data.text}</div>
                            <div class="seller-message__contents__items__body--icons">
                              <time class="seller-message__contents__items__body--icons--left">
                                <i class="fas fa-clock"></i>
                                <span>
                                ${data.created_at}
                                </span>
                              </time>
                              <div class="seller-message__contents__items__body--icons--right">
                                <div class="seller-message__contents__items__body--icons--right--delete" data-product=${data.product_id} data-comment=${data.id}>
                                  <i class="fas fa-trash-alt"></i>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </li> 
                    </ul>
                  </div>`
        return html
    }
  }

  $('.comment__new').on('submit', function(e){
    e.preventDefault();
    let url = $(this).attr('action');
    let formdata = new FormData(this);

    $.ajax({
      url: url,
      type: "POST",
      data: formdata,url,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    .done(function(data){
      let html = buildHTML(data);
      $(".insert_comment").append(html);
      $('.comment__new')[0].reset();
      $('.comment__new--submit').attr('disabled', false);
    })
    .fail(function(){
      alert("コメントの投稿にに失敗しました");
    })
  });

  $(document).on('click','.seller-message__contents__items__body--icons--right--delete', function(){
    let productId = $(this).data('product');
    let commentId = $(this).data('comment');
    $(this).parent().parent().parent().parent().remove();
    $.ajax({
      url: "/products/" + productId + "/comments/" + commentId ,
      type: "POST",
      data: {"_method": "DELETE" },
      dataType: 'json'
    })
    .done(function(){
      alert("コメントを削除しました");
    })
    .fail(function(){
      alert("コメントの削除に失敗しました");
    })
  });
});