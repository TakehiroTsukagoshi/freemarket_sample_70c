json.id @comment.id
json.user_id @comment.user_id
json.product_id @comment.product_id
json.text    @comment.text
json.nickname @comment.user.nickname
json.created_at @comment.created_at.strftime("%Y年%m月%d日 %H時%M分")
json.product_id @product.id