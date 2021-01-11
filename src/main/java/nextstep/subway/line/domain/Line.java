package nextstep.subway.line.domain;

import nextstep.subway.common.BaseEntity;
import nextstep.subway.station.domain.Station;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Entity
public class Line extends BaseEntity implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(unique = true)
    private String name;
    private String color;

    @OneToMany(mappedBy = "line", cascade = {CascadeType.PERSIST, CascadeType.MERGE}, orphanRemoval = true)
    private List<Section> sections = new ArrayList<>();

    public Line() {
    }

    public Line(String name, String color) {
        this.name = name;
        this.color = color;
    }

    public Line(String name, String color, Station upStation, Station downStation, int distance) {
        this.name = name;
        this.color = color;
        sections.add(new Section(this, upStation, downStation, distance));
    }

    public void update(Line line) {
        this.name = line.getName();
        this.color = line.getColor();
    }

    public void addLineSection(Station upStation, Station downStation, int distance) {
        boolean isUpStationExisted = isExisted(upStation);
        boolean isDownStationExisted = isExisted(downStation);

        valid(isUpStationExisted, isDownStationExisted);

        if (isUpStationExisted) {
            updateUpStation(upStation, downStation, distance);
        }

        if (isDownStationExisted) {
            updateDownStation(upStation, downStation, distance);
        }
        sections.add(new Section(this, upStation, downStation, distance));
    }

    public void removeStation(Long stationId) {
        if (sections.size() <= 1) {
            throw new IllegalArgumentException("라인에서 역을 제거할 수 없습니다.");
        }

        Optional<Section> upLineStation = findUpstation(stationId);
        Optional<Section> downLineStation = findDownStation(stationId);

        if (upLineStation.isPresent() && downLineStation.isPresent()) {
            createSection(upLineStation.get(), downLineStation.get());
        }

        upLineStation.ifPresent(it -> sections.remove(it));
        downLineStation.ifPresent(it -> sections.remove(it));
    }

    public List<Station> getStations() {
        if (sections.isEmpty()) {
            return Arrays.asList();
        }

        return orderBySection();
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getColor() {
        return color;
    }

    public List<Section> getSections() {
        return sections;
    }

    private List<Station> orderBySection() {
        List<Station> stations = new ArrayList<>();
        Station station = findFirstStation();
        stations.add(station);

        while (isPresentNextSection(station)) {
            Section nextSection = findNextSection(station);
            station = nextSection.getDownStation();
            stations.add(station);
        }
        return stations;
    }

    private Station findFirstStation() {
        Station upStation = sections.get(0).getUpStation();
        while (isPresentPreSection(upStation)) {
            Section nextSection = findPreSection(upStation);
            upStation = nextSection.getUpStation();
        }
        return upStation;
    }

    private boolean isPresentPreSection(Station station) {
        return sections.stream()
            .filter(Section::existDownStation)
            .anyMatch(it -> it.equalDownStation(station));
    }

    private boolean isPresentNextSection(Station station) {
        return sections.stream()
            .filter(Section::existUpStation)
            .anyMatch(it -> it.equalUpStation(station));
    }

    private Section findPreSection(Station station) {
        return sections.stream()
            .filter(it -> it.equalDownStation(station))
            .findFirst()
            .orElseThrow(() -> new IllegalArgumentException("이전 구간이 없습니다."));
    }

    private Section findNextSection(Station down) {
        return sections.stream()
            .filter(it -> it.equalUpStation(down))
            .findFirst()
            .orElseThrow(() -> new IllegalArgumentException("다음 구간이 없습니다."));
    }

    private void valid(boolean isUpStationExisted, boolean isDownStationExisted) {
        if (isUpStationExisted && isDownStationExisted) {
            throw new IllegalArgumentException("이미 등록된 구간 입니다.");
        }

        if (!getSections().isEmpty() && !isUpStationExisted && !isDownStationExisted) {
            throw new IllegalArgumentException("등록할 수 없는 구간 입니다.");
        }
    }

    private void updateDownStation(Station upStation, Station downStation, int distance) {
        sections.stream()
            .filter(it -> it.getDownStation() == downStation)
            .findFirst()
            .ifPresent(it -> it.updateDownStation(upStation, distance));
    }

    private void updateUpStation(Station upStation, Station downStation, int distance) {
        sections.stream()
            .filter(it -> it.getUpStation() == upStation)
            .findFirst()
            .ifPresent(it -> it.updateUpStation(downStation, distance));
    }

    private boolean isExisted(Station upStation) {
        return getStations().stream().anyMatch(it -> it == upStation);
    }

    private void createSection(Section upLineStation, Section downLineStation) {
        Station newUpStation = downLineStation.getUpStation();
        Station newDownStation = upLineStation.getDownStation();
        int newDistance = upLineStation.getDistance() + downLineStation.getDistance();
        sections.add(new Section(this, newUpStation, newDownStation, newDistance));
    }

    private Optional<Section> findDownStation(Long stationId) {
        return sections.stream()
            .filter(it -> it.equalDownStation(stationId))
            .findFirst();
    }

    private Optional<Section> findUpstation(Long stationId) {
        return sections.stream()
            .filter(it -> it.equalUpStation(stationId))
            .findFirst();
    }
}
