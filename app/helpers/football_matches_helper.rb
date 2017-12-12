module FootballMatchesHelper
  def first_page(url)
    url == '/' ? '/?page=1' : url
  end
end
