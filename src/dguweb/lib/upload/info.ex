defmodule DGUWeb.Upload.Info do
    defstruct filename: "", content_type: "", path: "", size: -1, warnings: [], errors: []

    def from_upload(upload) do
        # We have to move this file before the request completes.
        newpath = "/tmp/#{upload.filename}"
        :ok = File.cp(upload.path, newpath)
        {:ok, stat} = File.stat(newpath)

        %__MODULE__{
            filename: upload.filename,
            content_type: upload.content_type,
            path: newpath,
            size: stat.size,
        }
    end

    def from_url(url) do
        %__MODULE__{
            filename: url,
        }
    end
end

