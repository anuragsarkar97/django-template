module Commit

  class Mash < Hashie::Mash
    # https://github.com/hashie/hashie/issues/423
    # Disabled only in k8s where this class produces a large amount of WARN logs
    # The WARN should be fixed gradually
    disable_warnings unless ENV['K8S_HOST_IP'].nil?
  end

  class Code
    # Production hash is obtained by a file thats created from capistrano deploy, this is a hack and should be moved to ENV vars like staging
    def self.version_hash(raise_on_cap_no_file: true)
      git_hash = nil
      if Rails.env.production?
        if ENV['GIT_COMMIT_HASH_SHORT']
          git_hash = ENV['GIT_COMMIT_HASH_SHORT']
        else
          git_hash = get_cap_version(raise_on_cap_no_file)
        end
      elsif Rails.env.staging?
        git_hash = ENV['GIT_COMMIT_HASH_SHORT']
      elsif Rails.env.development?
        git_hash = `git rev-parse --short HEAD`.strip rescue nil
      end

      git_hash
    end

    def self.get_cap_version(raise_on_cap_no_file)
      file_path = "#{Rails.root}/REVISION"
      begin
        return File.read(file_path).strip
      rescue Errno::ENOENT => error
        if raise_on_cap_no_file
          raise error
        else
          Rails.logger.warn('Could not find capistrano revision file')
          return nil
        end
      end
    end
  end

  class Pod
    def self.hostname_to_number
      seed = Digest::SHA256.hexdigest(Socket.gethostname).to_i(16)
      r = Random.new(seed)
      r.rand
    end
  end
end
