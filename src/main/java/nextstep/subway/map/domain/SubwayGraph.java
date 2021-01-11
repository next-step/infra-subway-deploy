package nextstep.subway.map.domain;

import nextstep.subway.line.domain.Line;
import nextstep.subway.line.domain.Section;
import nextstep.subway.station.domain.Station;
import org.jgrapht.graph.WeightedMultigraph;

import java.util.List;
import java.util.stream.Collectors;

public class SubwayGraph extends WeightedMultigraph<Station, SectionEdge> {
    public SubwayGraph(Class edgeClass) {
        super(edgeClass);
    }

    public void addVertexWith(List<Line> lines) {
        // 지하철 역(정점)을 등록
        lines.stream()
                .flatMap(it -> it.getStations().stream())
                .distinct()
                .collect(Collectors.toList())
                .forEach(this::addVertex);
    }

    public void addEdge(List<Line> lines) {
        // 지하철 역의 연결 정보(간선)을 등록
        for (Line line : lines) {
            line.getSections().stream()
                    .forEach(it -> addEdge(it, line));
        }
    }

    private void addEdge(Section section, Line line) {
        SectionEdge sectionEdge = new SectionEdge(section, line.getId());
        addEdge(section.getUpStation(), section.getDownStation(), sectionEdge);
        setEdgeWeight(sectionEdge, section.getDistance());
    }
}
