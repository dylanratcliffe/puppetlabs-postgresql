require 'spec_helper_acceptance'

describe 'postgresql_conf', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  # rubocop:disable Metrics/LineLength
  it 'is able to manage multiple instances' do
    tmpdir = default.tmpdir('postgresql_conf')
    pp = <<-MANIFEST
      file { '#{tmpdir}/postgresql.conf':
        ensure => file,
      }
      file { '#{tmpdir}/postgresql2.conf':
        ensure => file,
      }
      postgresql_conf { 'instance 1 log_checkpoints':
        name   => 'log_checkpoints',
        value  => 'on',
        target => '#{tmpdir}/postgresql.conf'
      }
      postgresql_conf { 'instance 2 log_checkpoints':
        name   => 'log_checkpoints',
        value  => 'on',
        target => '#{tmpdir}/postgresql2.conf'
      }
    MANIFEST

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end
end
