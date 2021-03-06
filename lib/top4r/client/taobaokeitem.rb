class Top4R::Client
  @@TAOBAOKEITEM_METHODS = {
    :taobaoke_items_get => 'taobao.taobaoke.items.get'
  }
  
  def taobaoke_items(q = nil, method = :taobaoke_items_get, options = {}, &block)
    valid_method(method, @@TAOBAOKEITEM_METHODS, :taobaoke_item)
    options = {:keyword => q}.merge(options) if q
    params = {:fields => Top4R::TaobaokeItem.fields, :v => "2.0"}.merge(options)
    response = http_connect {|conn| create_http_get_request(@@TAOBAOKEITEM_METHODS[method], params)}
    result = JSON.parse(response.body)[rsp(@@TAOBAOKEITEM_METHODS[method])]
    if result.is_a?(Hash) and result["taobaoke_items"]
      items = Top4R::TaobaokeItem.unmarshal(result["taobaoke_items"]["taobaoke_item"])
      items.each {|item| bless_model(item); yield item if block_given?}
      @total_results = result["total_results"].to_i
    else
      @total_results = 0
      items = []
    end
    items
  end
end