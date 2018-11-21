# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "uri"

require "google/cloud/vision/v1/image_annotator_client"

module Google
  module Cloud
    module Vision
      module V1
        class ImageAnnotatorClient
          def face_detection images: [], image: nil, options: nil, &blk
            requests = sync_request_helper image, images, { type: :FACE_DETECTION }, options, &blk
          end

          def landmark_detection images: [], image: nil, options: nil, &blk
            requests = sync_request_helper image, images, { type: :LANDMARK_DETECTION }, options, &blk
          end

          def logo_detection images: [], image: nil, options: nil, &blk
            requests = sync_request_helper image, images, { type: :LOGO_DETECTION }, options, &blk
          end

          def label_detection images: [], image: nil, options: nil, &blk
            requests = sync_request_helper image, images, { type: :LABEL_DETECTION }, options, &blk
          end

          def text_detection images: [], image: nil, options: nil, &blk
            requests = sync_request_helper image, images, { type: :TEXT_DETECTION }, options, &blk
          end

          def document_text_detection images: [], image: nil, options: nil, &blk
            requests = sync_request_helper image, images, { type: :DOCUMENT_TEXT_DETECTION }, options, &blk
          end

          def safe_search_detection images: [], image: nil, options: nil, &blk
            requests = sync_request_helper image, images, { type: :SAFE_SEARCH_DETECTION }, options, &blk
          end

          def image_properties images: [], image: nil, options: nil, &blk
            requests = sync_request_helper image, images, { type: :IMAGE_PROPERTIES }, options, &blk
          end

          def crop_hints_detection images: [], image: nil, options: nil, &blk
            requests = sync_request_helper image, images, { type: :CROP_HINTS }, options, &blk
          end

          def web_detection images: [], image: nil, options: nil, &blk
            requests = sync_request_helper image, images, { type: :WEB_DETECTION }, options, &blk
          end

          def object_localization_detection images: [], image: nil, options: nil, &blk
            requests = sync_request_helper image, images, { type: :OBJECT_LOCALIZATION }, options, &blk
          end

          private

          def normalize_image image
            if File.file? image
              { content: File.binread(image) }
            elsif image =~ URI::DEFAULT_PARSER.make_regexp
              if URI(image).scheme == "gs"
                source = { gcs_image_uri: image }
                { source: source }
              else
                source = { image_uri: image }
                { source: source }
              end
            else
              raise TypeError.new("Image must be a filepath, file, url, or Google Cloud Storage url")
            end
          end

          def sync_request_helper image, images, feature, options, &blk
            images << image if image
            requests = images.map do |img|
              {
                image: normalize_image(img),
                features: [feature]
              }
            end
            batch_annotate_images requests, options, &blk
          end

        end
      end
    end
  end
end
