# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://gartenkalender.herokuapp.com"
SitemapGenerator::Sitemap.sitemaps_host = "http://gartenkalender.s3.amazonaws.com"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new(
                                         fog_provider: 'AWS',
                                         aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                         aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                                         fog_directory: ENV['S3_BUCKET_NAME'],
                                         fog_region: 'us-east')

SitemapGenerator::Sitemap.create do

  add '/search/index'

  add '/static_pages/contact'
  add '/static_pages/impressum'
  add '/static_pages/recommendations'

  Plant.friendly.where(public: true).find_each do |plant|
    images = []
    if plant.main_image.file?
      images.push({:loc  => download_main_image_plant_path(plant),
                   :title => plant.name })
    end
    add plant_path(plant),
      :lastmod => plant.updated_at,
      :images  => images

    last_mod_comment = plant.comments.order(updated_at: :desc).take
    if last_mod_comment
      add plant_comments_path(plant), :lastmod => last_mod_comment.updated_at
    end

    newest_task = plant.tasks.order(updated_at: :desc).take
    if newest_task
      add plant_tasks_path(plant), :lastmod => newest_task.updated_at
    end

    plant.tasks.find_each do |task|
      add plant_task_path(plant, task), :lastmod => task.updated_at
    end
  end
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
end
