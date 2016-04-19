defmodule ExSitemapGenerator.Location do
  alias ExSitemapGenerator.Namer
  alias ExSitemapGenerator.Adapter.File, as: FileAdapter

  defstruct [
    adapter: FileAdapter,
    public_path: "",
    filename: "sitemap",
    sitemaps_path: "sitemaps/",
    host: "http://www.example.com",
    namer: Namer,
    verbose: true,
    compress: true,
    create_index: :auto
  ]

  defp namestate(name) do
    String.to_atom(Enum.join([__MODULE__, name]))
  end

  def start_link(name) do
    Agent.start_link(fn -> %__MODULE__{} end, name: namestate(name))
  end

  def state(name) do
    Agent.get(namestate(name), &(&1))
  end

  def directory(name) do
    s = state(name)
    (s.public_path <> s.sitemaps_path).expand_path.to_s
  end

  def write(name, data, _count) do
    s = state(name)
    s.adapter.write(name, data)
  end

end
